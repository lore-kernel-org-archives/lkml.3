Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3JTX6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 19:58:11 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44197 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3JTX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 19:58:09 -0400
Message-ID: <52646E0E.6040204@gmail.com>
Date: Sun, 20 Oct 2013 19:58:06 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Linux Torvalds <torvalds@osdl.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2] x86: add kconfig options for newer 64-bit processors
References: <526325C9.7030705@gmail.com> <20131020091813.GA4972@pd.tnic>
In-Reply-To: <20131020091813.GA4972@pd.tnic>
X-Enigmail-Version: 1.5.2
OpenPGP: id=85D2EC0F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2013 05:18 AM, Borislav Petkov wrote:
> On Sat, Oct 19, 2013 at 08:37:29PM -0400, Austin S Hemmelgarn wrote:
>> This patch adds options to specifically optimize for a number of newer
>> 64-bit microarchitectures; specifically, Intel's Nehalem, Westmere,
>> Ivy Bridge, and Sandy Bridge, and AMD's Family 10h, Bobcat, Jaguar,
>> Bulldozer, Piledriver, and Steamroller. This serves primarily as an
>> attempt to render this particular sub-menu up-to-date with respect to
>> the options offered by current versions of GCC.
> 
> I'm sorry but did I miss anything from the last time where we determined
> that those don't bring any sensible speedup and don't mean whit on
> distros?
> 
> Thanks.
> 

I am not trying to say that this provides any improvement in speed (or
at least the AMD options, the one for Intel Ivy Bridge processors does
appear to do better in this respect).  As I stated in the comments just
before the patch itself, "...testing of MPILEDRIVER seems to indicate an
improvement to energy efficiency over GENERIC_CPU as it causes the on
cpu power sensor to consistently read an average of 1.5 watts lower
under idle load than when using GENERIC_CPU (this corresponds to about
5% decrease in power consumption on a idle-tickless system, and about 2%
on a non-dynticks system.).".  While this result is dependent on a large
number of factors (not the least of which being that I have my CPU
over-clocked to the point that the lowest C-state runs at 1.4GHz, which
really hurts energy efficiency) it is still a positive result, and most
of the equivalent options primarily improve energy efficiency.

Also, you have to understand that my target audience isn't the
mainstream distros, it's HPC users, data-centers, scientific computing,
and other areas where a 0.01% increase in efficiency is significant
because if you need a million servers to do a job, a 0.01% boost in
efficiency means that you need ten-thousand fewer systems to do the same
amount of work.
