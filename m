Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3JULo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:44:59 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61712 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3JULo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:44:56 -0400
Message-ID: <526513B5.5050203@gmail.com>
Date: Mon, 21 Oct 2013 07:44:53 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Linux Torvalds <torvalds@osdl.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2] x86: add kconfig options for newer 64-bit processors
References: <526325C9.7030705@gmail.com> <20131020091813.GA4972@pd.tnic> <52646E0E.6040204@gmail.com> <20131021105401.GA5019@nazgul.tnic>
In-Reply-To: <20131021105401.GA5019@nazgul.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-21 06:54, Borislav Petkov wrote:
> On Sun, Oct 20, 2013 at 07:58:06PM -0400, Austin S Hemmelgarn wrote:
>> I am not trying to say that this provides any improvement in speed (or
>> at least the AMD options, the one for Intel Ivy Bridge processors does
>> appear to do better in this respect).
>
> "Does appear" is not a very good answer - you need to give concrete
> benchmark results which people can repeat on their own and confirm your
> observations.
>
Specifically, boot time was reduced by approximately half a second
(measured as time from starting init till having a usable graphical
login), and the system ran approximately 1 degree cooler under heavy
load (namely a full GCC+binutils bootstrap with one job per virtual CPU
core).
>> As I stated in the comments just before the patch itself, "...testing
>> of MPILEDRIVER seems to indicate an improvement to energy efficiency
>> over GENERIC_CPU as it causes the on cpu power sensor to consistently
>> read an average of 1.5 watts lower under idle load than when
>> using GENERIC_CPU (this corresponds to about 5% decrease in power
>> consumption on a idle-tickless system, and about 2% on a non-dynticks
>> system.).". While this result is dependent on a large number of
>> factors (not the least of which being that I have my CPU over-clocked
>> to the point that the lowest C-state runs at 1.4GHz, which really
>> hurts energy efficiency) it is still a positive result, and most of
>> the equivalent options primarily improve energy efficiency.
>
> Again, how exactly do I reproduce your observations on my boxes? I need
> a step-by-step walk through please.
>
Using lm_sensors with CONFIG_FAM15H_POWER enabled, simply run the
command `sensors` a couple of times on an idle system as root comparing
the values between having CONFIG_MPILEDRIVER=y and CONFIG_GENERIC_CPU=y.
For this specific case I recorded the wattage values at one minute
intervals for 2 hours on both and took the arithmetic mean of the 120
data points in each case.
>> Also, you have to understand that my target audience isn't the
>> mainstream distros,...
>
> Well, if your target audience is only a very small fraction of the linux
> users, then we don't need this in the mainline kernel in the first
> place, do we?
>
Just because the target audience isn't the mainstream distros doesn't
mean that it's a very small fraction of the Linux users, based on just
the number of systems running Linux, Google is probably the biggest
user, followed closely by supercomputers.  I know that most
supercomputer operators do run custom builds of the kernel because they
need maximal efficiency, and Google is also known to run custom kernel
builds to try and increase performance.  These are my primary intended
audience followed closely by users of Gentoo and similar distros that
build the kernel locally in preference to distributing pre-built kernel
images.
> Thanks.
>
Something else to keep in mind, the effects of -mtune=generic change
over time, as these processors become less common, the optimizations
done by -mtune=generic will shift away from them.  The reason that many
of the equivalent options in the kernel currently provide as much
benefit as they do is that gcc no longer tries to create machine code
that is tuned for them unless you tell it to.
