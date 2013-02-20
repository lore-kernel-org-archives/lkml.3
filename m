Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3BTXBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:01:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:43540 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3BTXBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:01:12 -0500
Date: Thu, 21 Feb 2013 00:01:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ out-of-range ID
In-Reply-To: <20130220224019.GI3570@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1302202358220.22263@ionos>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org> <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org> <20130220140551.8017e795.akpm@linux-foundation.org> <20130220220823.GH3570@htj.dyndns.org> <20130220224019.GI3570@htj.dyndns.org>
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

> When idr_find() is fed a negative ID, it used to look up the ID
> ignoring the sign bit before recent ("idr: remove MAX_IDR_MASK and
> move left MAX_IDR_* into idr.c") patch, and triggers WARN_ON_ONCE()
> after it.
> 
> __lock_timer() feeds timer_id from userland directly to idr_find()
> without sanitizing it which can trigger the above malfunctions.  Add a
> range check on @timer_id before invoking idr_find() in __lock_timer().
> 
> While timer_t is defined as int by all archs at the moment, Andrew
> worries that it may be defined as a larger type later on.  Make the
> test cover larger integers too so that it at least is guaranteed to
> not return the wrong timer.

Again. I totaly agree with that for stable, but I disagree that this
is the real fix.

idr_find() should simply return NULL, if "id < 0". Is it that hard?
 
Thanks,

	tglx
