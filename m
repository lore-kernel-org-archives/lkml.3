Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaAPNjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:39:21 -0500
Received: from [65.55.88.11] ([65.55.88.11]:25532 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752803AbaAPNjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:39:15 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(z579eh3416lzbb2dI98dI9371I15bfK1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz8275dh1de097h186068hz2fh95h839h947hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h19b6n1155h)
Date: Thu, 16 Jan 2014 14:37:53 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Marc C <marc.ceeeee@gmail.com>, Michal Simek <michal.simek@xilinx.com>,
        Mark Brown <broonie@kernel.org>, David Brown <davidb@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for Broadcom
 7445
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com> <61E0E2A7-F7FC-4397-8E92-06CC409912B9@gmail.com> <52D72FCD.1030005@gmail.com> <201401161219.01038.arnd@arndb.de>
In-Reply-To: <201401161219.01038.arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <0ed449b4-dad4-47a0-9f7d-c3423d4e50f1@TX2EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 12:19 PM, Arnd Bergmann wrote:
> On Thursday 16 January 2014, Marc C wrote:
>>> And then you can add a regular device driver to drivers/reset that provides a
>>> device_reset() API to other drivers, or a system-reset function to be registered as
>>> arm_pm_restart. This driver would use syscon_regmap_lookup_by_phandle() to get access
>>> to a regmap pointer, and then use either hardcoded offsets into the regmap, or get
>>> those offsets from numbers in the devicetree, as provided in the example above.
>>
>> I was able to port a standalone "reboot" driver using syscon + regmap. However, for the
>> SMP initialization case, it turns out that syscon is configured after SMP init. Do you
>> have any advice for this type of situation?
>>
>> I'd hate to go around in circles, but without resorting to hard-coded offsets, perhaps I
>> can just add the remaining "non-regmap" register offsets in the DT?
> 
> You are not the first one to stumble over this problem. There are
> two ways to get out of it, and we should probably implement both in
> the long run:
> 
> 1. Other platforms also require the syscon driver to be active before
> the regular device driver probing starts. Michal Simek has the same
> issue in the zynq clock driver that you have for SMP initialization.
> We have talked about this with Mark Brown already, and I think we will
> find a solution for this in the end, but it's not as straightforward
> as I first hoped. We can probably use help in this area.

I wouldn't say issue because we have created workaround which should be acceptable.
For more info.
https://lkml.org/lkml/2014/1/6/349  patch 2/7 is that what we have done
to get it work.
Also I hope that this can go to mainline before any nice solution will be find
not to stop work on others drivers which use regmap.

But there is definitely a space for doing this better.


> 2. There is actually no reason for the SMP code to be called this early,
> and multiple platforms would like to move SMP init to a later stage.
> Stephen Boyd has recently started reworking the way we do SMP init,
> and he may have some more insight.
> 
> In the meantime, I'd suggest you do the binding under the assumption
> that it will work eventually, and then work around the current limitations
> in the SMP code by looking for the device nodes you need and map them
> manually, as you did in the previous versions of your patch set.

Yep, that's exactly what we have done just because of other driver developing
till this is resolved.

Thanks,
Michal


