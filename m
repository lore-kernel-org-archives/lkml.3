Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaDQPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:16:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaDQPQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:16:10 -0400
Message-ID: <1397747767.6428.4.camel@linux-fkkt.site>
Subject: Re: question on read_barrier_depends
From: Oliver Neukum <oneukum@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 17 Apr 2014 17:16:07 +0200
In-Reply-To: <Pine.LNX.4.44L0.1404161119490.1334-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404161119490.1334-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 11:26 -0400, Alan Stern wrote:

> In addition, the following code in kfifo_get() does this:
> 
> 			*(typeof(__tmp->type))__val = \
> 				(__is_kfifo_ptr(__tmp) ? \
> 				((typeof(__tmp->type))__kfifo->data) : \
> 				(__tmp->buf) \
> 				)[__kfifo->out & __tmp->kfifo.mask]; \
> 			smp_wmb(); \
> 			__kfifo->out++; \
> 
> It looks like the smp_wmb() should really be smp_mb(), because it 
> separates the _read_ for val from the _write_ of kfifo->out.

But where is kfifo->out read at all?

	Regards
		Oliver



