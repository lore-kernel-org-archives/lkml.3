Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3J2Xrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:47:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62193 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750897Ab3J2Xrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:47:31 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>, Colin Cross <ccross@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Revert 9745cdb36da83aeec198650b410ca06304cf792 ("select: use freezable blocking call")?
Date: Wed, 30 Oct 2013 00:59:39 +0100
Message-ID: <2743817.FMScy6kurY@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+5PVA7tvmqsF4=n84jnB3YOM50pq8wkQN9S8EL06FnGD-DoYA@mail.gmail.com>
References: <1383075705.22833.18.camel@x220.thuisdomein> <52702170.7080003@intel.com> <CA+5PVA7tvmqsF4=n84jnB3YOM50pq8wkQN9S8EL06FnGD-DoYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 29, 2013 07:39:23 PM Josh Boyer wrote:
> On Tue, Oct 29, 2013 at 4:58 PM, Rafael J. Wysocki
> <rafael.j.wysocki@intel.com> wrote:
> > On 10/29/2013 8:41 PM, Paul Bolle wrote:
> >>
> >> 0) Summary: ever since I tried running (release candidates of) v3.11 on
> >> the two working i686s I still have lying around I ran into issues on
> >> resuming from suspend. Reverting 9745cdb36da83aeec198650b410ca06304cf792
> >> ("select: use freezable blocking call") resolves those issues.
> >>
> >> 1) Resuming from suspend on i686 on (release candidates of) v3.11 and
> >> later triggers issues like:
> >>      traps: systemd[1] general protection ip:b738e490 sp:bf882fc0 error:0
> >> in libc-2.16.so[b731c000+1b0000]
> >>
> >> and
> >>      traps: rtkit-daemon[552] general protection ip:804d6e5 sp:b6cb32f0
> >> error:0 in rtkit-daemon[8048000+d000]
> >>
> >> Once I hit the systemd error I can only get out of the mess that the
> >> system is at that point by power cycling it.
> >>
> >> 2) I bisected that issue to commit
> >> 9745cdb36da83aeec198650b410ca06304cf792 ("select: use freezable blocking
> >> call"). The, rather impressive, bisect log is pasted at the end of this
> >> message. It took 23 builds to pinpoint this issue in the v3.10..v3.11
> >> range! Sadly, I have no clue why that commit triggers this issue.
> >>
> >> 3) Reverting that commit on top of v3.12-rc7 gets me a system that
> >> resumes without issues. (That revert needed one trivial context change.
> >> Note that I haven't actually tried v3.12-rc7 plain. But v3.12-rc6 and
> >> earlier also had this issue, so I'm sure the revert did the trick for
> >> v3.12-rc7.)
> >>
> >> 4) Should this commit be reverted? Or is there a better fix?
> >
> >
> > In short, yes, it should.
> >
> > I've already queued up a revert of something very similar and I'm going to
> > revert this one too.
> 
> To be clear, that's queued for 3.12 which is releasing really soon
> now.  Is that correct?

Yes, it is.  I'm going to send a pull request with that tomorrow if all goes
well.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
