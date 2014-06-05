Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaFEKL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:11:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFEKL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:11:28 -0400
Date: Thu, 5 Jun 2014 03:11:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,
        JBottomley@Parallels.com, venkateshs@google.com,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v3 1/6] virtio_scsi: remove ACCESS_ONCE() and
 smp_read_barrier_depends()
Message-ID: <20140605101127.GA8633@infradead.org>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
 <1401881699-1456-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401881699-1456-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 01:34:54PM +0200, Paolo Bonzini wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> Access to tgt->req_vq is strictly serialized by spin_lock
> of tgt->tgt_lock, so the ACCESS_ONCE() isn't necessary.
> 
> smp_read_barrier_depends() in virtscsi_req_done was introduced
> to order reading req_vq and decreasing tgt->reqs, but it isn't
> needed now because req_vq is read from
> scsi->req_vqs[vq->index - VIRTIO_SCSI_VQ_BASE] instead of
> tgt->req_vq, so remove the unnecessary barrier.
> 
> Also remove related comment about the barrier.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
