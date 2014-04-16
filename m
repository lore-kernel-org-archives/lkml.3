Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaDPI27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:28:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaDPI25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:28:57 -0400
Message-ID: <1397634429.21891.13.camel@linux-fkkt.site>
Subject: question on read_barrier_depends
From: Oliver Neukum <oneukum@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Apr 2014 09:47:09 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am looking at memory ordering and a question hit me.
I was looking at the kfifo code. kfifo_put() has a barrier:

			)[__kfifo->in & __tmp->kfifo.mask] = \
				(typeof(*__tmp->type))__val; \
			smp_wmb(); \
			__kfifo->in++; \

Looking at kfifo_get() 

		__ret = !kfifo_is_empty(__tmp); \
		if (__ret) { \
			*(typeof(__tmp->type))__val = \
				(__is_kfifo_ptr(__tmp) ? \

A thought struck me. There is no corresponding barrier. I cannot
help myself, but I think there needs to be a smp_read_barrier_depends()
between reading kfifo->in (in kfifo_is empty) and reading val.
What do you think?

	Regards
		Oliver


