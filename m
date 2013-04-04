Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763778Ab3DDUBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:01:22 -0400
Received: from numascale.com ([213.162.240.84]:41627 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763121Ab3DDUBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:01:20 -0400
Message-ID: <515DDC0F.7070406@numascale.com>
Date: Thu, 04 Apr 2013 22:01:19 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
References: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com> <20130404161340.GF32271@pd.tnic> <515DC0FA.1040408@numascale.com> <20130404190731.GG32271@pd.tnic>
In-Reply-To: <20130404190731.GG32271@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: sp@numascale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2013 9:07 PM, Borislav Petkov wrote:
> On Thu, Apr 04, 2013 at 08:05:46PM +0200, Steffen Persvold wrote:
>> It made more sense (to me) to skip the creation of MC4 all together
>> if you can't find the matching northbridge since you can't reliably
>> do the dec_and_test() reference counting on the shared bank when you
>> don't have the common NB struct for all the shared cores.
>>
>> Or am I just smoking the wrong stuff ?
>
> No, actually *this* explanation should've been in the commit message.
> You numascale people do crazy things with the hardware :) so explaining
> yourself more verbosely is an absolute must if anyone is to understand
> why you're changing the code.

Ok :)

>
> So please write a detailed commit message why you need this change,
> don't be afraid to talk about the big picture.

Will do.

>
> Also, I'm guessing this is urgent stuff and it needs to go into 3.9?
> Yes, no? If yes, this patch should probably be tagged for stable.

Yes. We found the issue on -stable at first (3.8.2 iirc) because it 
doesn't have the multi-domain support we needed (which is added in 3.9).

>
> Also, please redo this patch against tip:x86/ras which already has
> patches touching mce_amd.c.

Ok.

>
> Oh, and lastly, needless to say, it needs to be tested on a "normal",
> i.e. !numascale AMD multinode box, in case you haven't done so yet. :-)
>

It has been tested on "normal" platforms and NumaConnect platforms 
(Fam10h and Fam15h AMD processors, SCM and MCM versions).

Cheers,
Steffen
