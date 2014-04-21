Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaDUODT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:03:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42501 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751136AbaDUODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:03:17 -0400
Date: Mon, 21 Apr 2014 10:03:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on read_barrier_depends
In-Reply-To: <1398073259.9256.3.camel@linux-fkkt.site>
Message-ID: <Pine.LNX.4.44L0.1404211002080.1201-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014, Oliver Neukum wrote:

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
> On the third hand, I now think wmb() is sufficient, because
> there's also a write to __val. It does depend on the read
> of buf[out & mask], but if no CPU does speculative writes
> it must be correct.

You are right; I missed that.  Good point.

Alan Stern

