Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541Ab3BTJiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:38:10 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:20106 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab3BTJiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:38:04 -0500
Subject: Re: prctl(PR_SET_MM)
To: gorcunov@openvz.org (Cyrill Gorcunov)
Date: Wed, 20 Feb 2013 20:38:01 +1100 (EST)
Cc: rostedt@goodmis.org (Steven Rostedt), u3557@dialix.com.au,
        oleg@redhat.com (Oleg Nesterov), palves@redhat.com (Pedro Alves),
        dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        xemul@parallels.com (Pavel Emelyanov),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20130220083958.GS20312@moon>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130220093801.2EE67592064@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

Cyrill Gorcunov wrote:

> On Tue, Feb 19, 2013 at 05:25:31PM +1100, Amnon Shiloh wrote:
> > 
> > To reconstruct Linux process(es), one must be able to restore all their
> > memory contents, states and registers to their original and consistent
> > values.
> 
> I personally don't mind if this come become y by default, because it will
> work for us.

I don't mind either, to say the least, to have CONFIG_CHECKPOINT_RESTORE
have a "default y" in "init/Kconfig" - that would solve my problem and make
me happy, as well as your group and others, but we are told here that Linus
has a policy vetoing such changes and I don't believe either of us can make
him change his mind.

As such, we must look at other options, such as having the code in
"kernel/sys.c" out in the open, not enclosed by any #ifdef's altogether
- surely you would like that!

> Still I guess if you need to reconstruct Linux process(es)
> plain prctl extension is not enough, you still need a functionality which
> is enclosed in config-checkpoint-restore (say /proc/pid/map_files, kcmp),
> no?

My process-migration package only reconstructs Linux processes partially:
as it's a bit different than any classical checkpoint-restore, the critical
code in "kernel/sys.c" is all I need at the moment (from within
CONFIG_CHECKPOINT_RESTORE).  I do appreciate that anyone attempting to
perform complete, classical, checkpoint-restore operations, needs more
than that.

Best Regards,
Amnon.
