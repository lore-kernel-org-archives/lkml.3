Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3FYKTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:19:20 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:43817 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab3FYKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:19:15 -0400
Message-ID: <51C96D85.7080507@st.com>
Date: Tue, 25 Jun 2013 11:14:29 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jiri Slaby <jslaby@suse.cz>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5] serial:st-asc: Add ST ASC driver.
References: <1372058503-30505-1-git-send-email-srinivas.kandagatla@gmail.com> <20130624233813.GA4108@kroah.com>
In-Reply-To: <20130624233813.GA4108@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 00:38, Greg Kroah-Hartman wrote:
> On Mon, Jun 24, 2013 at 08:21:43AM +0100, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> This patch adds support to ASC (asynchronous serial controller)
>> driver, which is basically a standard serial driver. This IP is common
>> across all the ST parts for settop box platforms.
>>
>> ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
>> It support all industry standard baud rates.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> CC: Stephen Gallimore <stephen.gallimore@st.com>
>> CC: Stuart Menefy <stuart.menefy@st.com>
>> CC: Arnd Bergmann <arnd@arndb.de>
>> ---
>> Hi Greg,
>>
>> This patch is the part of the driver support for Stixxxx SOCs.
>> This patch undergone 3-4 cycles of review in arm-kernel mailing list.
>> As Arnd prefered to take only SOC support patches via arm-soc, Am 
>> sending this patch seperately.
>>
>> If its not too late, can you consider this patch for 3.11 via tty tree?
> 
> I would have taken it, but it breaks the build on my machine:
Thanks Greg,

I know the problem, some of the members in struct device are conditional
with PINCTRL support.
I think that's breaking build on your machine.

I will fix it and resend as you suggested.

Thanks,
srini
> 
> drivers/tty/serial/st-asc.c: In function ‘asc_serial_resume’:
> drivers/tty/serial/st-asc.c:774:15: error: ‘struct device’ has no member named ‘pins’
> drivers/tty/serial/st-asc.c:775:3: error: implicit declaration of function ‘pinctrl_select_state’ [-Werror=implicit-function-declaration]
> drivers/tty/serial/st-asc.c:775:37: error: ‘struct device’ has no member named ‘pins’
> drivers/tty/serial/st-asc.c:776:16: error: ‘struct device’ has no member named ‘pins’
> 
> Please test your patches out on a "normal" Linux system.

> 
> Please feel free to resend this after 3.11-rc1 is out, for inclusion in
> 3.12, after you have fixed the build problems.
> 
> greg k-h
> 
> 

