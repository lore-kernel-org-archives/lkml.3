Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaBJNzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:55:00 -0500
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:37993 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbaBJNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:54:59 -0500
Message-ID: <52F8DA09.2010302@st.com>
Date: Mon, 10 Feb 2014 14:54:17 +0100
From: Fabrice Gasnier <fabrice.gasnier@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "vgupta@synopsys.com" <vgupta@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.coquelin@st.com" <maxime.coquelin@st.com>
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com> <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com> <20140207170903.GT5976@mudshark.cambridge.arm.com> <52F892C8.80508@st.com> <20140210111710.GC17766@mudshark.cambridge.arm.com>
In-Reply-To: <20140210111710.GC17766@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/10/2014 12:17 PM, Will Deacon wrote:
> On Mon, Feb 10, 2014 at 08:50:16AM +0000, Fabrice Gasnier wrote:
>> On 02/07/2014 06:09 PM, Will Deacon wrote:
>>> On Fri, Feb 07, 2014 at 04:19:15PM +0000, Fabrice GASNIER wrote:
>>>> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
>>>> index 4636d56..ef15709 100644
>>>> --- a/arch/arm/kernel/traps.c
>>>> +++ b/arch/arm/kernel/traps.c
>>>> @@ -900,6 +900,10 @@ void __init early_trap_init(void *vectors_base)
>>>>    
>>>>    	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
>>>>    	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
>>>> +
>>>> +	/* Enable imprecise aborts */
>>>> +	local_abt_enable();
>>> Surely we want to enable this as early as possible? Now, putting this into
>>> head.S is ugly, as it duplicating it across all the proc*.S files, so why
>>> not setup_arch?
>> Sorry, I'm not sure to understand your last comment.
>> At least, I need it enabled before probing drivers (PCIe bus)
>> I've added imprecise abort enable code in traps.c, following Russel
>> King's advice, please see:
>> http://archive.arm.linux.org.uk/lurker/message/20140131.170827.d752a1cc.en.html
>> As abort bit is local to a cpu, i've also added it in smp.c, but this
>> may not be the right place ?
>>
>> Please elaborate,
> I was just suggesting that we move your local_abt_enable() call to
> setup_arch, since that's called before early_trap_init on the primary CPU.
Thanks for the clarification. Yes, maybe others would like to have it 
enabled as you suggest.
My point is, it's good enough for such use case to do it in early_trap_init.
I'd prefer to follow Russel's first advice.

Fabrice
>
> Will

