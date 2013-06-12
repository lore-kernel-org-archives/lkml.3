Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3FLKs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:48:59 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:49385 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab3FLKs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:48:57 -0400
Message-ID: <51B85151.2060409@st.com>
Date: Wed, 12 Jun 2013 11:45:37 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 02/11] clocksource:global_timer: Add ARM global timer
 support.
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856087-6452-1-git-send-email-srinivas.kandagatla@st.com> <CACRpkdbQCRKBzRF4HzNsXHwXCLJJcFZ9T36GPmmYsnX1OfgGRg@mail.gmail.com> <51B5D7A6.1020101@st.com> <51B72E9A.6070006@st.com> <CACRpkdbppRqnMYknbBy8JpAVtujMOEQvyczXTmpvkQuxgikFog@mail.gmail.com>
In-Reply-To: <CACRpkdbppRqnMYknbBy8JpAVtujMOEQvyczXTmpvkQuxgikFog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/13 21:13, Linus Walleij wrote:
> On Tue, Jun 11, 2013 at 4:05 PM, Srinivas KANDAGATLA
> <srinivas.kandagatla@st.com> wrote:
> 
>> Doing this is not adding any value to the driver, because
>>  1. Currently the driver only support DT boot paths, in my previous RFC
>> patches, Arnd suggested to get rid of the header as all platforms are DT
>> now.
> 
> In that case why do you have the separate global_timer_init()
> at all? Just move that code into global_timer_of_register() and
> also remove the #ifdef around CONFIG_OF and make the driver
> depend on CONFIG_OF in Kconfig.
> 
> After this you realize that all that business with
> clk_register_clkdev() / clk_get_sys() is just pure surplus
> baggade, you just use of_clk_get() and that's it.

It makes sense to move all the code into global_timer_of_register().
This will also get rid of un-used code. I will do this in the next spin.

Thanks,
srini

> 
> Yours,
> Linus Walleij
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

