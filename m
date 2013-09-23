Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3IWUOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:14:18 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:56537 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab3IWUOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:14:17 -0400
Date: Mon, 23 Sep 2013 16:14:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "majianpeng@gmail.com" <majianpeng@gmail.com>
Subject: Re: [PATCH v2 1/2] elevator: Fix a race in elevator switching and md
 device initialization
Message-ID: <20130923201412.GA28667@mtj.dyndns.org>
References: <20130922170417.GF30946@htj.dyndns.org>
 <CE661700.7BC5%Tomoki.Sekiyama@hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE661700.7BC5%Tomoki.Sekiyama@hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 23, 2013 at 08:11:55PM +0000, Tomoki Sekiyama wrote:
> >Hmm... why aren't we just changing elevator_init() to grab sysfs_lock
> >where necessary?  
> 
> The locking cannot be moved into elevator_init() because it is called
> from elevator_switch() path, where the request_queue's sysfs_lock is
> already taken.
> 
> > It'd be more consistent with elevator_exit() that way.
> 
> What elevator_exit() locks is elevator_queue's sysfs_lock, not
> request_queue's sysfs_lock. What we need here is request_queue's
> sysfs_lock.

Ah, okay.

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
