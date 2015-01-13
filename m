Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbbAMQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:25:58 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbAMQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:25:57 -0500
Date: Tue, 13 Jan 2015 08:25:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, axboe@fb.com, tom.leiming@gmail.com
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
Message-ID: <20150113162553.GA24351@infradead.org>
References: <1420926734-16417-1-git-send-email-richard@nod.at>
 <1420926734-16417-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420926734-16417-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	struct ubi_sgl usgl;

Btw, what's in struct ubi_sgl?  Can't find that in my tree.

> +static void ubiblock_do_work(struct work_struct *work)
> +{
> +	int ret;
> +	struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
> +	struct request *req = blk_mq_rq_from_pdu(pdu);
> +
> +	blk_mq_start_request(req);
> +	blk_rq_map_sg(req->q, req, pdu->usgl.sg);

blk_rq_map_sg returns the number of entries actually mapped, which
might be smaller than the number passed in due to merging.

