Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3KDOQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:16:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab3KDOQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:16:29 -0500
Date: Mon, 4 Nov 2013 09:16:16 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131104141615.GD9944@hansolo.jdub.homelinux.org>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131103101825.GA6605@gmail.com>
 <20131103102132.GA6807@gmail.com>
 <20131103155729.GB9944@hansolo.jdub.homelinux.org>
 <20131104065343.GC13030@gmail.com>
 <20131104140141.GC9944@hansolo.jdub.homelinux.org>
 <20131104141051.GA19355@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104141051.GA19355@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 03:10:51PM +0100, Ingo Molnar wrote:
> 
> * Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > > Why touch MAXSMP at all? It's really just a shortcut for 'configure 
> > > the kernel silly large', via a single option, nothing else. You are 
> > > not forced to use it and it should not affect configurability of 
> > > NR_CPUS.
> > >
> > > What we _really_ want here is to fix NR_CPUS setting: to extend its 
> > > range and to enforce that NR_CPUS cannot be set larger than 512 
> > > without setting CONFIG_CPUMASK_OFFSTACK.
> > 
> > OK.  I was just thinking that if we've come to the conclusion that 4096 
> > CPUs isn't silly large anymore, we should make MAXSMP be something we 
> > consider silly large. [...]
> 
> MAXSMP is also supposed to track the real hardware max as well on x86 - 
> i.e. we should only increase it to 8192 etc. if such hardware exists.

Russ, does SGI (or anyone else that you know of) have x86 hardware with
more than 4096 CPUs?

If so, I can actually make a bump to the MAXSMP count a separate patch.

josh
