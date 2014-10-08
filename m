Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbaJHMPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:15:07 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:53226 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJHMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:15:05 -0400
Date: Wed, 8 Oct 2014 08:15:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Arun KS <getarunks@gmail.com>
Cc: Arun KS <arunks.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        laijs@cn.fujitsu.com, Silesh C V <saileshcv@gmail.com>
Subject: Re: [Workqueue] crash in process_one_work
Message-ID: <20141008121502.GA8184@htj.dyndns.org>
References: <CAKZGPAPS+x2V3Ajj323EUStpWGmZ6taOuovjqA3_kaYXA3T_Ag@mail.gmail.com>
 <20141006153224.GC18303@htj.dyndns.org>
 <CABOM9ZpEhh7PnJT0hRa=Jx1CfYTU0QTG_71Qz-iB3VxygsYgzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABOM9ZpEhh7PnJT0hRa=Jx1CfYTU0QTG_71Qz-iB3VxygsYgzw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arun.

On Wed, Oct 08, 2014 at 05:30:20PM +0530, Arun KS wrote:
> > I sure hope not.  How reproducible is the issue?  Can you try w/
> > CONFIG_DEBUG_OBJECTS_WORK enabled?
> 
> Thanks for replying.
> That was a problem with one of our driver. It was freeing the
> memory(struct work) without flushing workqueue.
> We caught faulty driver by adding a BUG_ON() in INIT_WORK and looking
> at the func pointer in work_struct( which will be pointing to the
> faulty driver work function)
> 
> 1) faulty driver queue_work to system_unbownded_wq
> 2) free work_struct memory, but it is still queued in the work queue.
> 3) another driver request the memory from SLAB, go the same memory, it INIT_WORK
> 4) process work try to execute the work queued by the faulty driver,
> result in a crash.

Ah, good to hear.  I think bugs like the above should be detectable
with CONFIG_DEBUG_OBJECTS_WORK, so if you see something similar next
time, please try it out.

Thanks.

-- 
tejun
