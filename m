Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaCNRis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:38:48 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:42140 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753709AbaCNRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:38:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:4321:4385:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12740:13019:13069:13311:13357:13548,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cakes60_69152e42b3015
X-Filterd-Recvd-Size: 1608
Message-ID: <1394818720.3253.1.camel@joe-AO722>
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
From: Joe Perches <joe@perches.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com
Date: Fri, 14 Mar 2014 10:38:40 -0700
In-Reply-To: <1394818263-29947-1-git-send-email-tytso@mit.edu>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-14 at 13:31 -0400, Theodore Ts'o wrote:
> The current virtio block sets a queue depth of 64.  With a
> sufficiently fast device, using a queue depth of 256 can double the
> IOPS which can be sustained.  So make the queue depth something which
> can be set at module load time or via a kernel boot-time parameter.
[]
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
[]
> @@ -481,6 +481,9 @@ static struct blk_mq_ops virtio_mq_ops = {
>  	.free_hctx	= blk_mq_free_single_hw_queue,
>  };
>  
> +static int queue_depth = 64;
> +module_param(queue_depth, int, 444);

444?  Really Ted?

0444



