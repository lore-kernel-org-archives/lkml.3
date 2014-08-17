Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaHQPsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:48:35 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:47811 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHQPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:48:33 -0400
Message-ID: <1408290480.3306.17.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Does anyone know when FUTEX_WAIT can fail with EAGAIN?
From: Davidlohr Bueso <dave@stgolabs.net>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, mtk@man7.org,
        davidlohr@hp.com
Date: Sun, 17 Aug 2014 08:48:00 -0700
In-Reply-To: <fb82d1d46d8f.53d8186c@langara.bc.ca>
References: <fb82d1d46d8f.53d8186c@langara.bc.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 21:55 +0000, Steven Stewart-Gallus wrote:
> Hello,
> 
> I'm trying to debug a hangup where my program loops with FUTEX_WAIT (actually
> FUTEX_WAIT_PRIVATE but same thing)  endlessly erring out with EAGAIN. I would
> like to know if anyone on the mailing list knows when FUTEX_WAIT can fail with
> EAGAIN.

You're probably running into the EWOULDBLOCK return -- which on Linux is
just another name for EAGAIN. So if you didn't know this, and were
reading the code related to FUTEX_WAIT, you'd get mislead by this.

The check is there to avoid userspace misusing futexes and screwing up
applications. When the futex_wait() call is issued, a lot can happen in
the kernel before the task is blocked (key hashing, reference counting,
acquire internal spinlock, etc.). At any point while preparing to block,
another userspace thread could have changed the futex value, and thus
the condition for which futex_wait() call was issued in the first place
might no longer be true.

Thanks,
Davidlohr

