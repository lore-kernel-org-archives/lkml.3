Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769Ab3BTJiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:38:54 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58016 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3BTJiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:38:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="24255950"
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="435321326"
From: "Bu, Yitian" <ybu@qti.qualcomm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: RE: [PATCH] Fix rq->lock vs logbuf_lock unlock race
Thread-Topic: [PATCH] Fix rq->lock vs logbuf_lock unlock race
Thread-Index: AQHOD0aoTqiQYklW0USvuaYJaBrXc5iCd8nw
Date: Wed, 20 Feb 2013 09:38:28 +0000
Message-ID: <E807E903FE6CBE4D95E420FBFCC273B827522A@nasanexd01h.na.qualcomm.com>
References: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
 <1361349910.10155.0.camel@laptop>
In-Reply-To: <1361349910.10155.0.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.48.1]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1K9ct2h002807



> -----Original Message-----
> From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> Sent: Wednesday, February 20, 2013 4:45 PM
> To: Bu, Yitian
> Cc: tglx@linutronix.de; linux-kernel@vger.kernel.org; mingo@kernel.org
> Subject: Re: [PATCH] Fix rq->lock vs logbuf_lock unlock race
> 
> On Mon, 2013-02-18 at 12:53 +0000, Bu, Yitian wrote:
> > This patch is for kernel V3.7.9
> >
> > From 8796f4a2175a323aaa49ea8dd0fe68678dd5dccd Mon Sep 17 00:00:00
> 2001
> > From: ybu <ybu@qti.qualcomm.com>
> > Date: Mon, 18 Feb 2013 19:52:01 +0800
> > Subject: [PATCH] Fix rq->lock vs logbuf_lock unlock race
> >
> > fix up the fallout from commit 07354eb1a74d1 ("locking printk:
> > Annotate logbuf_lock as raw")
> > Release console_sem after unlocking the logbuf_lock avoids some lock
> > inversion troubles between logbuf_lock and rq->lock.
> 
> Please clarify how and where.. you're not actually supposed to use
> printk() while holding rq->lock.
> 

1. the patch 0b5e1c5255e, which is written by you,  release console_sem
after logbuf_lock. But the patch 07354eb1a revert one of your change, it 
reintroduced a lock inversion problem which was fixed in 0b5e1c5255.
The purpose of my patch is the same as your patch 0b5e1c5255e.

2. from printk comment: "This is printk(). It can be called from any context. 
We want it to work. ". I suppose to use printk in any context.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
