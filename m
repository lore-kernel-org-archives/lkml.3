Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935067AbaKNCQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:16:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:60664 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933518AbaKNCQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:16:21 -0500
Date: Thu, 13 Nov 2014 21:16:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH RESEND 3.18-rc3 v2 0/2] trace: kdb: Bug fixes for ftdump
Message-ID: <20141113211616.0b9fbcf1@gandalf.local.home>
In-Reply-To: <5460884C.1050401@linaro.org>
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
	<1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
	<20141106082728.5d4b7161@gandalf.local.home>
	<5460884C.1050401@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 09:41:32 +0000
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> On 06/11/14 13:27, Steven Rostedt wrote:
> > On Thu,  6 Nov 2014 12:41:54 +0000
> > Daniel Thompson <daniel.thompson@linaro.org> wrote:
> > 
> >> This patchset makes it possible to use kdb's ftdump command without
> >> panicing, crashing or livelocking. The ftdump command cannot be used
> >> at all without these changes.
> >>
> >> IIRC this patches are still pending Jason's ack.
> > 
> > I haven't heard from Jason in a long time. Is he still active?
> 
> [sorry for the delay, I wanted to give Jason a chance to answer this]
> 
> Very occasionally.
> 
> I can't find anything on lkml in the last three months, and I have
> unreviewed kdb patches that stretch back well beyond that.
> 
> That said he still helps people on kgdb-bugreport@ from time-to-time
> (and as recently as last week). I've also had a little bit of private
> contact although nothing very recent.
> 
> On that basis I'd say you shouldn't feel guilty if you have to accept a
> change here without an ack.
> 

He had more than enough time to respond. OK, I'll take it.

Looking at the first patch, I notice that there's no protection of the
static buffer_iter array. I also noticed that there's no protection of
the static iter itself (which was there before your patch). I take it
that this code is not re-entrant.


Thanks!

-- Steve
