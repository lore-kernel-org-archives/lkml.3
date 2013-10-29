Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3J2XjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:39:25 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60155 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3J2XjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:39:23 -0400
MIME-Version: 1.0
In-Reply-To: <52702170.7080003@intel.com>
References: <1383075705.22833.18.camel@x220.thuisdomein>
	<52702170.7080003@intel.com>
Date: Tue, 29 Oct 2013 19:39:23 -0400
X-Google-Sender-Auth: TwBxVlaOYLpKPAqVD4kQ347bxxQ
Message-ID: <CA+5PVA7tvmqsF4=n84jnB3YOM50pq8wkQN9S8EL06FnGD-DoYA@mail.gmail.com>
Subject: Re: Revert 9745cdb36da83aeec198650b410ca06304cf792 ("select: use
 freezable blocking call")?
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Colin Cross <ccross@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 4:58 PM, Rafael J. Wysocki
<rafael.j.wysocki@intel.com> wrote:
> On 10/29/2013 8:41 PM, Paul Bolle wrote:
>>
>> 0) Summary: ever since I tried running (release candidates of) v3.11 on
>> the two working i686s I still have lying around I ran into issues on
>> resuming from suspend. Reverting 9745cdb36da83aeec198650b410ca06304cf792
>> ("select: use freezable blocking call") resolves those issues.
>>
>> 1) Resuming from suspend on i686 on (release candidates of) v3.11 and
>> later triggers issues like:
>>      traps: systemd[1] general protection ip:b738e490 sp:bf882fc0 error:0
>> in libc-2.16.so[b731c000+1b0000]
>>
>> and
>>      traps: rtkit-daemon[552] general protection ip:804d6e5 sp:b6cb32f0
>> error:0 in rtkit-daemon[8048000+d000]
>>
>> Once I hit the systemd error I can only get out of the mess that the
>> system is at that point by power cycling it.
>>
>> 2) I bisected that issue to commit
>> 9745cdb36da83aeec198650b410ca06304cf792 ("select: use freezable blocking
>> call"). The, rather impressive, bisect log is pasted at the end of this
>> message. It took 23 builds to pinpoint this issue in the v3.10..v3.11
>> range! Sadly, I have no clue why that commit triggers this issue.
>>
>> 3) Reverting that commit on top of v3.12-rc7 gets me a system that
>> resumes without issues. (That revert needed one trivial context change.
>> Note that I haven't actually tried v3.12-rc7 plain. But v3.12-rc6 and
>> earlier also had this issue, so I'm sure the revert did the trick for
>> v3.12-rc7.)
>>
>> 4) Should this commit be reverted? Or is there a better fix?
>
>
> In short, yes, it should.
>
> I've already queued up a revert of something very similar and I'm going to
> revert this one too.

To be clear, that's queued for 3.12 which is releasing really soon
now.  Is that correct?

josh
