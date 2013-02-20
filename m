Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3BTVrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:47:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:43109 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3BTVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:47:19 -0500
Date: Wed, 20 Feb 2013 22:47:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Sasha Levin <sasha.levin@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
In-Reply-To: <20130220214346.GF3570@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1302202246110.22263@ionos>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org> <alpine.LFD.2.02.1302202208470.22263@ionos>
 <20130220214346.GF3570@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Tejun Heo wrote:

> Hey, Thomas.
> 
> On Wed, Feb 20, 2013 at 10:38:36PM +0100, Thomas Gleixner wrote:
> > I can grumpily accept the patch below as a quick hack fix, which can
> > go to stable as well, but not with such a patently misleading
> > changelog.
> > 
> > The changelog wants to document, that this is not a proper fix at all
> > and just a quick hack which can be nonintrusively applied to stable.
> 
> I'm not sure about what type timer_t can be but if it can actually be
> u64 as Andrew suggests, we probably want a different test guarding it.
> 
> > > Note that the previous code was theoretically broken.  idr_find()
> > > masked off the sign bit before performing lookup and if the matching
> > > IDs were in use, it would have returned pointer for the incorrect
> > > entry.
> > 
> > Brilliant code that. What's the purpose of having the idr id as an
> > "int" and then masking off the sign bit instead of simply refusing
> > negative id values in the idr code itself or simply making the id
> > "unsigned int" ?
> 
> Beats me.  The code has been like that since the beginning.  One of
> the many oddities of idr implementation.  Patch to remove MAX_IDR_MASK
> is already queued in -mm w/ other idr updates.

Missed that, but good to know that this insanity is going to be gone
soon.

Thanks,

	tglx
