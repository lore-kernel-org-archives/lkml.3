Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3BTXJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:09:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:43579 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3BTXJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:09:50 -0500
Date: Thu, 21 Feb 2013 00:09:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
In-Reply-To: <20130220140551.8017e795.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1302210003380.22263@ionos>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org> <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org> <20130220140551.8017e795.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Andrew Morton wrote:
> On Wed, 20 Feb 2013 13:37:01 -0800
> Tejun Heo <tj@kernel.org> wrote:
> > hopefully with some comments.  That said, if I'm grepping it right,
> > all archs define timer_t as int, so maybe we're just being paranoid.
> > 
> 
> Sure, it's unlikely to cause a problem in practice.  Maybe five years
> from now, after idr has been cleaned up and switched to 64-bit, we've
> left a little hand grenade for someone.  It would be good to
> future-safe it in some fashion.
> 
> I wonder if we should add some generic facility to handle this:
> 
> /*
>  * Query whether an unsigned type is `negative' when we don't know its size
>  */
> #define msb_is_set(v)	{ implementation goes here ;) }
> 
> Maybe not justified, dunno...

First of all the compiler should warn you about the truncation. And
aside of that:

+ BUILD_BUG_ON(sizeof(timer_t) != sizeof(int));

and then we can worry about that esoteric architecture when that thing
triggers?

Aside of that, due to the pending checkpoint/restore stuff this user
might be gone in the near future.

Thanks,

	tglx

