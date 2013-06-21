Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab3FUHUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:20:19 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:48966 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758794Ab3FUHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:20:15 -0400
Message-ID: <51C3FD90.8010505@st.com>
Date: Fri, 21 Jun 2013 08:15:28 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 02/10] clocksource:arm_global_timer: Add ARM global
 timer support.
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com> <1371737121-9295-1-git-send-email-srinivas.kandagatla@st.com> <201306202102.30478.arnd@arndb.de>
In-Reply-To: <201306202102.30478.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 20:02, Arnd Bergmann wrote:
> On Thursday 20 June 2013, Srinivas KANDAGATLA wrote:
>> +static u64 gt_counter_read(void)
>> +{
>> +       u64 counter;
>> +       u32 lower;
>> +       u32 upper, old_upper;
>> +
>> +       upper = __raw_readl(gt_base + GT_COUNTER1);
>> +       do {
>> +               old_upper = upper;
>> +               lower = __raw_readl(gt_base + GT_COUNTER0);
>> +               upper = __raw_readl(gt_base + GT_COUNTER1);
>> +       } while (upper != old_upper);
>> +
>> +       counter = upper;
>> +       counter <<= 32;
>> +       counter |= lower;
>> +       return counter;
>> +}
> 
> Please replace __raw_readl etc with the non-__raw variants
> throughout the code.
> 
> The __raw accessors are not endian safe and are not meant
> for device drivers. If you are worried about latency from
> extra barriers, use readl_relaxed().
Endian safe is good point. I will move to using readl/writel which does
both ordering and byteswapping.
And use relaxed versions in gt_counter_read to reduce the latency.

looks like smp_twd.c too needs this type of change.

Thanks,
srini

> 
> 	Arnd
> 

