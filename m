Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaBCO6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:58:06 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaBCO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:58:04 -0500
Date: Mon, 3 Feb 2014 06:57:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linuxnfs <linux-nfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viro Alexander <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: NFS client broken in Linus' tip
Message-ID: <20140203145759.GA30263@infradead.org>
References: <20140130140834.GW15937@n2100.arm.linux.org.uk>
 <20140130141405.GA23985@infradead.org>
 <20140130142752.GX15937@n2100.arm.linux.org.uk>
 <20140130143208.GB9573@infradead.org>
 <20140130153812.GA15937@n2100.arm.linux.org.uk>
 <1391201970.6978.1.camel@leira.trondhjem.org>
 <20140203080325.GB806@infradead.org>
 <85AAFCF5-60EE-42E5-B103-37A4613C5947@primarydata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85AAFCF5-60EE-42E5-B103-37A4613C5947@primarydata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 09:17:30AM -0500, Trond Myklebust wrote:
> As I said above, that causes posix_acl_xattr_get() to return the wrong answer (ENODATA instead of EOPNOTSUPP).

Is it really the wrong answer?  How does userspace care wether this
server doesn't support ACLs at all or none is set?  The resulting
behavior is the same.

If there's a good reason to care we might have to go with your patch,
but if we can avoid it I'd prefer to keep things simple.
