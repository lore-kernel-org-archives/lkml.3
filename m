Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450Ab3BTKTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:19:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51015 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3BTKTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:19:19 -0500
Message-ID: <1361355555.10155.14.camel@laptop>
Subject: Re: [PATCH] Fix rq->lock vs logbuf_lock unlock race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Bu, Yitian" <ybu@qti.qualcomm.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Date: Wed, 20 Feb 2013 11:19:15 +0100
In-Reply-To: <E807E903FE6CBE4D95E420FBFCC273B827522A@nasanexd01h.na.qualcomm.com>
References: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
	 <1361349910.10155.0.camel@laptop>
	 <E807E903FE6CBE4D95E420FBFCC273B827522A@nasanexd01h.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 09:38 +0000, Bu, Yitian wrote:
> 
> 2. from printk comment: "This is printk(). It can be called from any
> context. 
> We want it to work. ". I suppose to use printk in any context.

Unfortunately that's not quite possible, rq->lock is really out of
bounds. At one point I tried 'fixing' this but there's a whole bunch of
nasty that's not going to go away.

I've since forgotten most of the details, but aside from logbuf problems
there's a whole host of issues with the console drivers themselves as
well.

If you really want to do this, use early_printk.

