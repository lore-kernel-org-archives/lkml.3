Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab3BTIpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:45:19 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42285
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756933Ab3BTIpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:45:17 -0500
Message-ID: <1361349910.10155.0.camel@laptop>
Subject: Re: [PATCH] Fix rq->lock vs logbuf_lock unlock race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Bu, Yitian" <ybu@qti.qualcomm.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Date: Wed, 20 Feb 2013 09:45:10 +0100
In-Reply-To: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
References: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 12:53 +0000, Bu, Yitian wrote:
> This patch is for kernel V3.7.9
> 
> From 8796f4a2175a323aaa49ea8dd0fe68678dd5dccd Mon Sep 17 00:00:00 2001
> From: ybu <ybu@qti.qualcomm.com>
> Date: Mon, 18 Feb 2013 19:52:01 +0800
> Subject: [PATCH] Fix rq->lock vs logbuf_lock unlock race
> 
> fix up the fallout from commit 07354eb1a74d1 ("locking printk:
> Annotate logbuf_lock as raw")
> Release console_sem after unlocking the logbuf_lock avoids some lock
> inversion troubles between logbuf_lock and rq->lock.

Please clarify how and where.. you're not actually supposed to use
printk() while holding rq->lock.


