Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaLWCyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 21:54:00 -0500
Received: from r00tworld.com ([212.85.137.150]:60525 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbaLWCx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 21:53:59 -0500
X-Greylist: delayed 2736 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 21:53:58 EST
From: "PaX Team" <pageexec@freemail.hu>
To: linux-kernel@vger.kernel.org, rogelio.serrano@gmail.com
Date: Tue, 23 Dec 2014 03:08:10 +0100
MIME-Version: 1.0
Subject: Re: atomic_inc and spin_lock_irq
Reply-to: pageexec@freemail.hu
Message-ID: <5498CE8A.26946.7AAE3D1@pageexec.freemail.hu>
In-reply-to: <CAB_-8bLk-HVWB6Mmt=rjDguou1kbGQ9c7o5nQxV3zAg+Txf7GQ@mail.gmail.com>
References: <CAB_-8bLk-HVWB6Mmt=rjDguou1kbGQ9c7o5nQxV3zAg+Txf7GQ@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.70)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Tue, 23 Dec 2014 03:08:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Dec 2014 at 21:07, Rogelio M. Serrano Jr. wrote:

> whats the difference between:
> 
> atomic_inc(&port->count);
> 
> and
> 
> spin_lock_irq(&port->lock);
> ++port->count;
> spin_unlock_irq(&port->lock);

in PaX this kind of change brings the ->count accesses under the coverage
of the REFCOUNT feature. if the kernel had a non-atomic refcount type and
corresponding accessors, they'd be used here instead.

