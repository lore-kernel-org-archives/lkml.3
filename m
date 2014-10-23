Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaJWKvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:51:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:21113 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753253AbaJWKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:51:17 -0400
Date: Thu, 23 Oct 2014 06:51:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Peter Foley <pefoley2@pefoley.com>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Fix output of make kernelrelease
Message-ID: <20141023065107.587ab9f6@gandalf.local.home>
In-Reply-To: <5448C315.9000001@suse.cz>
References: <20141022101944.70d637cc@gandalf.local.home>
	<20141022194408.GA20989@pobox.suse.cz>
	<20141022211115.576b0053@gandalf.local.home>
	<5448C315.9000001@suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 10:57:57 +0200
Michal Marek <mmarek@suse.cz> wrote:

> On 2014-10-23 03:11, Steven Rostedt wrote:
> > On Wed, 22 Oct 2014 21:44:08 +0200
> > Michal Marek <mmarek@suse.cz> wrote:
> > 
> >> Dne 22.10.2014 v 16:19 Steven Rostedt napsal(a):
> >>>
> >>> Commit 7ff525712acf "kbuild: fake the "Entering directory ..." message
> >>> more simply" changed the output of "make kernelrelease" such that the
> >>> kernel release version was not the last line printed. This broke various
> >>> tools that would find the kernel release with "make kernelrelease | tail -1".
> >>
> >> The cleaner and recommended (see recent make help) way is to use make -s:
> >>
> >> $ make O=build -s kernelrelease
> >> 3.18.0-rc1+
> >>
> >> no further processing is needed.
> > 
> > 
> > I don't mind changing my script with your patch. But this does break
> > other scripts of mine that I need to hunt down and change. My fear is
> > why do we need the '-s' when there may be other methods to preserve the
> > old functionality.
> 
> If you have scripts that only do x=$(make kernelrelease), then you
> should definitely fix them. You are right that the make kernelrelease |
> tail -1 trick had always been working until 7ff525712acf, so I can apply
> your patch.

Thanks, because that's what my scripts indeed do ;-)

> But please fix ktest.pl so that it's consistent with what
> the help text says.

Yeah, regardless I was planning on applying your patch as it needs to
handle bisects, and without it, ktest will fail to bisect after
7ff525712acf.

> Also, the Makefile patch should cover kernelversion
> and image_name as well.

OK, I'll make the update.

Thanks!

-- Steve
