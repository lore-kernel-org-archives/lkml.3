Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3BMSfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:35:32 -0500
Received: from science.horizon.com ([71.41.210.146]:41632 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751661Ab3BMSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:35:31 -0500
Date: 13 Feb 2013 13:35:29 -0500
Message-ID: <20130213183529.27043.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gregkh@linuxfoundation.org, linux@horizon.com
Subject: Re: [PATCH v2 8/9] pps: Use a single cdev
Cc: giometti@linux.it, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, peter@hurleysoftware.com
In-Reply-To: <20130213182026.GA3996@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You forgot a Signed-off-by: line for this patch, so I can't apply it, or
> the 9/9 patch :(

Oops, fixed.  I don't see why the 9/9 patch depends on it,
though.  They're not related or interdependent in any way.

If you want to check the logic, I'd appreciate it.  I'm not
really sure about the RCU stuff.  My understanding is that:
- the idr code does the appropriate write locking when
  modifying itself, so I don't need to do any.
- The pps_device returned from idr_find is itself refcounted,
  so it can't go away, and the accesses don't have bo be
  inside the RCU read "lock".  It's only the IDR's internal
  index nodes that might get reallocated by modificaitons of
  a different part of the tree.

> Care to resend just these two after fixing this up?

I can, but if you think you need 9/9 resent (which *did* have a S-o-b),
I'm confused and wonder why...
