Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969Ab3BTKvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:51:14 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:32856 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab3BTKvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:51:13 -0500
Date: Wed, 20 Feb 2013 14:51:09 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, u3557@dialix.com.au,
        Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: prctl(PR_SET_MM)
Message-ID: <20130220105109.GW20312@moon>
References: <20130220083958.GS20312@moon>
 <20130220093801.2EE67592064@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220093801.2EE67592064@miso.sublimeip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 08:38:01PM +1100, Amnon Shiloh wrote:
> > I personally don't mind if this come become y by default, because it will
> > work for us.
> 
> I don't mind either, to say the least, to have CONFIG_CHECKPOINT_RESTORE
> have a "default y" in "init/Kconfig" - that would solve my problem and make
> me happy, as well as your group and others, but we are told here that Linus
> has a policy vetoing such changes and I don't believe either of us can make
> him change his mind.

That's perfectly fine for all new features :-)

> As such, we must look at other options, such as having the code in
> "kernel/sys.c" out in the open, not enclosed by any #ifdef's altogether
> - surely you would like that!
> 
> > Still I guess if you need to reconstruct Linux process(es)
> > plain prctl extension is not enough, you still need a functionality which
> > is enclosed in config-checkpoint-restore (say /proc/pid/map_files, kcmp),
> > no?
> 
> My process-migration package only reconstructs Linux processes partially:
> as it's a bit different than any classical checkpoint-restore, the critical
> code in "kernel/sys.c" is all I need at the moment (from within
> CONFIG_CHECKPOINT_RESTORE).  I do appreciate that anyone attempting to
> perform complete, classical, checkpoint-restore operations, needs more
> than that.

I see. Thanks for explanation! Thus we need some new config option which would
enable this prctl opcodes (y by default), in turn config-checkpoint-restore
kconfig option need to select this feature if set. Sounds reasonable?
