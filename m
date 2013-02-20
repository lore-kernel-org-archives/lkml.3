Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3BTWI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:08:29 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40421 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3BTWI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:08:28 -0500
Date: Wed, 20 Feb 2013 14:08:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
Message-ID: <20130220220823.GH3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
 <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
 <512522CF.1020901@oracle.com>
 <20130220210116.GD3570@htj.dyndns.org>
 <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org>
 <20130220140551.8017e795.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220140551.8017e795.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 02:05:51PM -0800, Andrew Morton wrote:
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

The thing is it's not only about MSB.  Any bits beyond 1 << 31 are
problematic, so we want a range test.

Thanks.

-- 
tejun
