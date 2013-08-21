Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3HUPGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:06:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3HUPGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:06:46 -0400
Date: Wed, 21 Aug 2013 11:06:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, joe.jin@oracle.com, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm ioctl: allow change device target type to error
Message-ID: <20130821150547.GA10987@redhat.com>
References: <5214CC25.1070307@oracle.com>
 <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21 2013 at 10:48am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 21 Aug 2013, Joe Jin wrote:
> 
> > commit a5664da "dm ioctl: make bio or request based device type immutable"
> > prevented "dmsetup wape_table" change the target type to "error".
> 
> That commit a5664da is there for a reason (it is not possible to change 
> bio-based device to request-based and vice versa) and I don't really see 
> how this patch is supposed to work.
> 
> If there are bios that are in flight and that already passed through 
> blk_queue_bio, and you change the device from request-based to bio-based, 
> what are you going to do with them? - The patch doesn't do anything about 
> it.
> 
> A better approach would be to create a new request-based target "error-rq" 
> and change the multipath target to "error-rq" target. That way, you don't 
> have to change device type from request based to bio based.

My thoughts _exactly_.  This patch is very confused.

Joe, what are you looking to be able to do?  Switch a dm-multipath
device to error?  Or allowing switching a target that has
DM_TARGET_IMMUTABLE flag set to be switched to error target?

The latter restriction was introduced with commit 36a0456fb ("dm table:
add immutable feature").

Mike
