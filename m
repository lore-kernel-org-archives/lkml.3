Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3HUGu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:50:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3HUGu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:50:27 -0400
Date: Tue, 20 Aug 2013 23:50:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: dl9pf@gmx.de
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix
 build for clang. No functional change otherwise.
Message-ID: <20130821065018.GB9043@infradead.org>
References: <1377033546-19475-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377033546-19475-1-git-send-email-dl9pf@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:19:06PM +0200, dl9pf@gmx.de wrote:
> From: Jan-Simon M??ller <dl9pf@gmx.de>
> 
> Author:  PaX Team <pageexec at freemail.hu>
> ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
> URL:     http://llvm.linuxfoundation.org
> 
> Merge:   Jan-Simon M??ller <dl9pf at gmx.de>
> 
> Description:
>   Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx" (outsw likewise);
>   GNU as accepts both forms.
> 
> Signed-off-by: Jan-Simon M??ller <dl9pf@gmx.de>

I think the right fix is to simply kill the FAST_READ_IO/FAST_WRITE_IO
defines and their associated inline assembly entirely.

