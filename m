Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFEKMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:12:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaFEKMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:12:42 -0400
Date: Thu, 5 Jun 2014 03:12:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,
        JBottomley@Parallels.com, venkateshs@google.com,
        Ulrich Obergfell <uobergfe@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 4/6] scsi_error: fix invalid setting of host byte
Message-ID: <20140605101242.GC8633@infradead.org>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
 <1401881699-1456-5-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401881699-1456-5-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 01:34:57PM +0200, Paolo Bonzini wrote:
> From: Ulrich Obergfell <uobergfe@redhat.com>
> 
> After scsi_try_to_abort_cmd returns, the eh_abort_handler may have
> already found that the command has completed in the device, causing
> the host_byte to be nonzero (e.g. it could be DID_ABORT).  When
> this happens, ORing DID_TIME_OUT into the host byte will corrupt
> the result field and initiate an unwanted command retry.
> 
> Fix this by using set_host_byte instead, following the model of
> commit 2082ebc45af9c9c648383b8cde0dc1948eadbf31.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
> [Fix all instances according to review comments. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
