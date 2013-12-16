Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3LPL5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:57:53 -0500
Received: from smtp-out-048.synserver.de ([212.40.185.48]:1119 "EHLO
	smtp-out-044.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753045Ab3LPL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:57:52 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11971
Message-ID: <52AEEAF4.3010703@metafoo.de>
Date: Mon, 16 Dec 2013 12:58:44 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2 03/16] ARM: dts: provide DMA config to pxamci
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> 	 <1386901645-28895-1-git-send-email-ynvich@gmail.com> 	 <1386901645-28895-4-git-send-email-ynvich@gmail.com> 	 <201312142006.26979.arnd@arndb.de>  <1387049660.7152.317.camel@host5.omatika.ru> <52AECEB2.4070807@gmail.com> <1387194450.13062.134.camel@host5.omatika.ru>
In-Reply-To: <1387194450.13062.134.camel@host5.omatika.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 12:47 PM, Sergei Ianovich wrote:
> On Mon, 2013-12-16 at 10:58 +0100, Daniel Mack wrote:
>> On 12/14/2013 08:34 PM, Sergei Ianovich wrote:
>>> On Sat, 2013-12-14 at 20:06 +0100, Arnd Bergmann wrote:
>>
>>>> The patch looks ok in case we are merging your patches for 3.14
>>>> and Daniel's patches later than that. If they end up in the
>>>> same merge window however, we'd have to be care to resolve
>>>> the obvious conflict in a proper way.
>>>
>>> The most recently published Daniel's patch (Aug 2013) wraps
>>> IORESOURCE_DMA handling on DT presence in a similar way,
>>
>> Erm, no it doesn't. My patch uses dma_request_slave_channel_compat() in
>> DT case, and that works fine with the current version of pdma, and
>> there's no need to read the "dmas" properties directly.
>>
>> If you want to provide a way to simply denote the dma channel numbers,
>> without looking at the actual phandle, then yes, we could merge this
>> patch first, but it would be effectively reverted a proper implementation.
> 
> Daniel is right. His patch doesn't need to read "dmas" directly. So my
> patch won't need to change drivers/mmc/host/pxamci.c at all, if it is
> applied after Daniel's one.
> 

Btw. any driver that parses the dmas property manually should be considered
broken. This is a classical layering violation. The layout of the dma
specifier is DMA controller specific and should be completely transparent to
the device driver.

- Lars
