Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628Ab3DIJpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:45:49 -0400
Received: from numascale.com ([213.162.240.84]:33787 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935338Ab3DIJpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:45:46 -0400
Message-ID: <5163E348.7060206@numascale.com>
Date: Tue, 09 Apr 2013 11:45:44 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
References: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com> <20130404161340.GF32271@pd.tnic> <515DC0FA.1040408@numascale.com> <20130404190731.GG32271@pd.tnic> <5163DE7C.7060700@numascale.com> <20130409093854.GC10243@pd.tnic>
In-Reply-To: <20130409093854.GC10243@pd.tnic>
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

On 4/9/2013 11:38 AM, Borislav Petkov wrote:
> On Tue, Apr 09, 2013 at 11:25:16AM +0200, Steffen Persvold wrote:
>> Why not let all cores just create their individual kobject and skip
>> this "shared" nb->bank4 concept ? Any disadvantage to that (apart from
>> the obvious storage bloat?).
>
> Well, bank4 is shared across cores on the northbridge in *hardware*.

Well, yes I was aware of that :)

> So it is only logical to represent the hardware layout correctly in
> software.
>
> Also, if you want to configure any settings over one core's sysfs nodes,
> you want those to be visible across all cores automagically:

Hmm, yes of course. This of course breaks on our slave servers when the 
shared mechanism doesn't work properly (i.e NB not visible). Then all 
cores gets individual kobjects and there can be discrepancies between 
what the hardware is programmed to and what is reflected in /sys on some 
cores..

Ok, we go with our first approach to not create MC4 at all if NB isn't 
visible.

We'll redo the patch against the tip:x86/ras branch.

Cheers,
Steffen

