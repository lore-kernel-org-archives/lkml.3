Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3HGGGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:06:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3HGGGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:06:49 -0400
Date: Tue, 6 Aug 2013 23:06:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Peng Tao <tao.peng@emc.com>, Kent Overstreet <koverstreet@google.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-aio@kvack.org
Subject: Re: [PATCH] staging/lustre: kiocb->ki_left is removed
Message-ID: <20130807060646.GA22815@infradead.org>
References: <1375792261-2674-1-git-send-email-bergwolf@gmail.com>
 <20130806150308.GB8043@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806150308.GB8043@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:03:08AM -0400, Benjamin LaHaise wrote:
> On Tue, Aug 06, 2013 at 08:31:01PM +0800, Peng Tao wrote:
> > From: Peng Tao <tao.peng@emc.com>
> > 
> > We also missed ki_nbytes...
> 
> Applied to the aio-next.git tree.

The correct fix would be to just switch the .read and .write entry
points in Lustre to use do_sync_read/write instead of reimplementing it
incorrectly.

