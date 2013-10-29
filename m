Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3J2U6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:58:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:35634 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab3J2U62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:58:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,595,1378882800"; 
   d="scan'208";a="419340628"
Message-ID: <52702170.7080003@intel.com>
Date: Tue, 29 Oct 2013 21:58:24 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Colin Cross <ccross@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
CC: Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Revert 9745cdb36da83aeec198650b410ca06304cf792 ("select: use
 freezable blocking call")?
References: <1383075705.22833.18.camel@x220.thuisdomein>
In-Reply-To: <1383075705.22833.18.camel@x220.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 8:41 PM, Paul Bolle wrote:
> 0) Summary: ever since I tried running (release candidates of) v3.11 on
> the two working i686s I still have lying around I ran into issues on
> resuming from suspend. Reverting 9745cdb36da83aeec198650b410ca06304cf792
> ("select: use freezable blocking call") resolves those issues.
>
> 1) Resuming from suspend on i686 on (release candidates of) v3.11 and
> later triggers issues like:
>      traps: systemd[1] general protection ip:b738e490 sp:bf882fc0 error:0 in libc-2.16.so[b731c000+1b0000]
>
> and
>      traps: rtkit-daemon[552] general protection ip:804d6e5 sp:b6cb32f0 error:0 in rtkit-daemon[8048000+d000]
>
> Once I hit the systemd error I can only get out of the mess that the
> system is at that point by power cycling it.
>
> 2) I bisected that issue to commit
> 9745cdb36da83aeec198650b410ca06304cf792 ("select: use freezable blocking
> call"). The, rather impressive, bisect log is pasted at the end of this
> message. It took 23 builds to pinpoint this issue in the v3.10..v3.11
> range! Sadly, I have no clue why that commit triggers this issue.
>
> 3) Reverting that commit on top of v3.12-rc7 gets me a system that
> resumes without issues. (That revert needed one trivial context change.
> Note that I haven't actually tried v3.12-rc7 plain. But v3.12-rc6 and
> earlier also had this issue, so I'm sure the revert did the trick for
> v3.12-rc7.)
>
> 4) Should this commit be reverted? Or is there a better fix?

In short, yes, it should.

I've already queued up a revert of something very similar and I'm going 
to revert this one too.

Thanks,
Rafael

