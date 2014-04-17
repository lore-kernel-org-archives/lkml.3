Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaDQPux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:50:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42514 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753036AbaDQPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:50:49 -0400
Date: Thu, 17 Apr 2014 11:50:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on read_barrier_depends
In-Reply-To: <1397747767.6428.4.camel@linux-fkkt.site>
Message-ID: <Pine.LNX.4.44L0.1404171149001.881-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014, Oliver Neukum wrote:

> On Wed, 2014-04-16 at 11:26 -0400, Alan Stern wrote:
> 
> > In addition, the following code in kfifo_get() does this:
> > 
> > 			*(typeof(__tmp->type))__val = \
> > 				(__is_kfifo_ptr(__tmp) ? \
> > 				((typeof(__tmp->type))__kfifo->data) : \
> > 				(__tmp->buf) \
> > 				)[__kfifo->out & __tmp->kfifo.mask]; \
> > 			smp_wmb(); \
> > 			__kfifo->out++; \
> > 
> > It looks like the smp_wmb() should really be smp_mb(), because it 
> > separates the _read_ for val from the _write_ of kfifo->out.
> 
> But where is kfifo->out read at all?

It is read in kfifo_put(), inside the call to kfifo_is_full() -> 
kfifo_len().

Alan Stern

