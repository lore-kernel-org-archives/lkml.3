Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaBLPPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:15:17 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:60658 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbaBLPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:15:15 -0500
Message-ID: <52FB8FD3.1020407@st.com>
Date: Wed, 12 Feb 2014 16:14:27 +0100
From: Fabrice Gasnier <fabrice.gasnier@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fabrice GASNIER <fabrice.gasnier@stericsson.com>
Cc: <u.kleine-koenig@pengutronix.de>, <jonathan.austin@arm.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>, <nico@linaro.org>,
        <sboyd@codeaurora.org>, <marc.zyngier@arm.com>,
        <ben.dooks@codethink.co.uk>, <vgupta@synopsys.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>
Subject: Re: [PATCH v2] ARM: Add imprecise abort enable/disable macro
References: <1392050756-11145-1-git-send-email-fabrice.gasnier@st.com> <52FB71A3.5010505@stericsson.com> <20140212131834.GP26684@n2100.arm.linux.org.uk>
In-Reply-To: <20140212131834.GP26684@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 02/12/2014 02:18 PM, Russell King - ARM Linux wrote:
> On Wed, Feb 12, 2014 at 02:05:39PM +0100, Fabrice GASNIER wrote:
>> Hi,
>>
>> Any comments on this patch ?
>>
>> Russell, can I add this patch to your patch tracker system ?
> I don't see how this works on anything but ARMv7M.

Sorry, i'm confused.

In the first patch you proposed,
http://archive.arm.linux.org.uk/lurker/message/20140131.170827.d752a1cc.en.html
there was :

#ifndef CONFIG_CPU_V7M

[...]

/* Enable imprecise aborts */
[...]

#else /* ifndef CONFIG_CPU_V7M */

I understand that abort handling (vectors and masking ?) is different on 
armv7-m ?
Or should we make no distinction ?

I have kept the same principle regarding abort enable/disable macro.

#if __LINUX_ARM_ARCH__ >= 6
[...]

#ifndef CONFIG_CPU_V7M
#define local_abt_enable()  __asm__("cpsie a    @ __sta" : : : "memory", 
"cc")
#define local_abt_disable() __asm__("cpsid a    @ __cla" : : : "memory", 
"cc")
#else
#define local_abt_enable()    do { } while (0)
#define local_abt_disable()    do { } while (0)
#endif

#else
[...]
#define local_abt_enable()    do { } while (0)
#define local_abt_disable()    do { } while (0)
#endif

Sorry if this is silly question ...

BR,
Fabrice
>

