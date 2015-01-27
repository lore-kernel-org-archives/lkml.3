Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbbA0Rar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:30:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbbA0Raq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:30:46 -0500
Date: Tue, 27 Jan 2015 09:30:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: P??draig Brady <P@draigBrady.com>
Cc: lkml <linux-kernel@vger.kernel.org>, aneesh.kumar@linux.vnet.ibm.com,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: RFC: More functions allowed with O_PATH
Message-ID: <20150127173045.GA21651@infradead.org>
References: <54C78B8F.9090903@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C78B8F.9090903@draigBrady.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:58:55PM +0000, P??draig Brady wrote:
> Since fsync(), fdatasync(), syncfs() work on an identifying descriptor,
> and all work against a read-only file for example,
> should any/all these functions work with a descriptor opened with O_PATH ?

fsync and fdatasync work on the file data, so they defintively
shouldn't.

syncfs might make sense as we just use it as a handle for the containing
filesystem.

Adding fchmod and fchown would be more useful as they are allowed by
Posix on O_EXEC and O_SEARCH fds.
