Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3BTVnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:43:51 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56732 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3BTVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:43:50 -0500
Date: Wed, 20 Feb 2013 13:43:46 -0800
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, Sasha Levin <sasha.levin@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
Message-ID: <20130220214346.GF3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
 <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
 <512522CF.1020901@oracle.com>
 <20130220210116.GD3570@htj.dyndns.org>
 <alpine.LFD.2.02.1302202208470.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302202208470.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Thomas.

On Wed, Feb 20, 2013 at 10:38:36PM +0100, Thomas Gleixner wrote:
> I can grumpily accept the patch below as a quick hack fix, which can
> go to stable as well, but not with such a patently misleading
> changelog.
> 
> The changelog wants to document, that this is not a proper fix at all
> and just a quick hack which can be nonintrusively applied to stable.

I'm not sure about what type timer_t can be but if it can actually be
u64 as Andrew suggests, we probably want a different test guarding it.

> > Note that the previous code was theoretically broken.  idr_find()
> > masked off the sign bit before performing lookup and if the matching
> > IDs were in use, it would have returned pointer for the incorrect
> > entry.
> 
> Brilliant code that. What's the purpose of having the idr id as an
> "int" and then masking off the sign bit instead of simply refusing
> negative id values in the idr code itself or simply making the id
> "unsigned int" ?

Beats me.  The code has been like that since the beginning.  One of
the many oddities of idr implementation.  Patch to remove MAX_IDR_MASK
is already queued in -mm w/ other idr updates.

Thanks.

-- 
tejun
