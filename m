Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbbANIkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:40:05 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbbANIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:40:00 -0500
Date: Wed, 14 Jan 2015 00:39:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@infradead.org>,
        user-mode-linux-devel@lists.sourceforge.net, dxld@darkboxed.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hostfs: Use noop_fsync for directories
Message-ID: <20150114083951.GA29714@infradead.org>
References: <1421187358-32600-1-git-send-email-richard@nod.at>
 <20150113221958.GA27739@infradead.org>
 <54B59B9E.4000806@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B59B9E.4000806@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:26:38PM +0100, Richard Weinberger wrote:
> hostfs tries do reduce the amount of syscall between guest and host as much
> as possible. For file operations it passes everything down to the host but
> for directory operations only ->iterate() does.
> 
> It is already horrible slow, if we add an ->open() for directory too it would
> get even more slower. :-(

This sounds fairlt dangerous.  At least add some good documentation
explaining these semantics.

