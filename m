Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3BDSHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:07:05 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:42892 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3BDSHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:07:03 -0500
Date: Mon, 4 Feb 2013 13:06:40 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        netdev@vger.kernel.org
Subject: Re: [PATCH 09/62] atm/nicstar: convert to idr_alloc()
Message-ID: <20130204130640.6a1795bb@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20130204170624.GJ27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<1359854463-2538-10-git-send-email-tj@kernel.org>
	<20130204090410.2942f8cc@thirdoffive.cmf.nrl.navy.mil>
	<20130204170624.GJ27963@mtj.dyndns.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013 09:06:24 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello, Chas.
> 
> On Mon, Feb 04, 2013 at 09:04:10AM -0500, chas williams - CONTRACTOR wrote:
> > I don't quite understand your comment.  idr_pre_get() returns 0 in the
> > case of failure.
> 
> So, if you do the following,
> 
> 	int id1 = 0, id2 = 0;
> 
> 	if (!id1)
> 		err = idr_get_new_above(&card->idr, handle1, 0, &id1);
> 	if (!id2 && err == 0)
> 		err = idr_get_new_above(&card->idr, handle2, 0, &id2);
> 	if (err)
> 		goto out;
> 									    
> You have no way of telling whether id1/2 are allocated or not.  0 is
> the special "not allocated" value but it also is a valid ID.  The
> error path should be freeing id1/2 if either of them has been
> allocated but it doesn't and can't with 0 as the non-allocated value.

yeah, i see now.  it didn't understand what idr_get_new_above() was
doing with the start id.  i assumed that it would return something
greater than the start id.  i guess it never did return the starting id
(atleast after some initial failure).

additionally, yes, cleaning up if the second allocation failed was never
done.
