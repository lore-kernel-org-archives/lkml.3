Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaAGP6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:58:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaAGP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:58:31 -0500
Date: Tue, 7 Jan 2014 07:58:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Sergey Meirovich <rathamahata@gmail.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gluk <git.user@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Message-ID: <20140107155830.GA28395@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106201032.GA13491@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:10:32PM +0100, Jan Kara wrote:
>   This is likely a problem of Linux direct IO implementation. The thing is
> that in Linux when you are doing appending direct IO (i.e., direct IO which
> changes file size), the IO is performed synchronously so that we have our
> life simpler with inode size update etc. (and frankly our current locking
> rules make inode size update on IO completion almost impossible). Since
> appending direct IO isn't very common, we seem to get away with this
> simplification just fine...

Shouldn't be too much of a problem at least for XFS and maybe even ext4
with the workqueue based I/O end handler.  For XFS we protect size
updates by the ilock which we already taken in that handler, not sure
what ext4 would do there.

