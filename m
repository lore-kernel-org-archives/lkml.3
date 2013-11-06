Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3KFV2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:28:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10859 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756094Ab3KFV2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:28:45 -0500
Date: Wed, 6 Nov 2013 16:28:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] avr32: Remove HAVE_KPROBES from avr32 Kconfig
Message-ID: <20131106162844.76119e9e@gandalf.local.home>
In-Reply-To: <20131106210520.GA6825@samfundet.no>
References: <20131106124330.4d73d200@gandalf.local.home>
	<20131106210520.GA6825@samfundet.no>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 22:05:21 +0100
Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:

> Around Wed 06 Nov 2013 12:43:30 -0500 or thereabout, Steven Rostedt wrote:
> 
> Hello,
> 
> > Although there's a arch/avr32/kernel/kprobes.c file, this arch does not
> > compile with kprobes enabled:
> > 
> >  In file included from cross-linux.git/arch/avr32/kernel/kprobes.c:14:
> >  cross-linux.git/include/linux/kprobes.h: In function 'get_kprobe_ctlblk':
> >  cross-linux.git/include/linux/kprobes.h:358: error: invalid use of undefined type 'struct kprobe_ctlblk'
> >  cross-linux.git/include/linux/kprobes.h:358: error: dereferencing pointer to incomplete type
> >  make[2]: *** [arch/avr32/kernel/kprobes.o] Error 1
> > 
> > This is because it does not define the required kprobe_ctlblk struct,
> > and fails to compile when CONFIG_KPROBES is set.
> > 
> > Unfortunately, this also makes my testing of various configs for
> > different archs to fail on avr32 as well.
> > 
> > If kprobes is not supported by avr32 than do not say that it is.
> 
> kprobes is supposed to be supported on AVR32, but it seems to have broken
> somewhere down the road.
> 
> I re-discovered an old patch fixing this from Eirik, I have added this to my
> for-linus branch instead of your proposed patch.
> 
> https://git.kernel.org/cgit/linux/kernel/git/egtvedt/linux-avr32.git/log/?h=for-linus
> 

That works too! I was hoping for a similar fix. I sent my patch more as
an incentive to get kprobes fixed than to disable it ;-)

Tested-by: Steven Rostedt <rostedt@goodmis.org> # only cross compiled tested

-- Steve
