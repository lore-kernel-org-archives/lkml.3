Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbbA1Upd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:45:33 -0500
Received: from verein.lst.de ([213.95.11.211]:34455 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbbA1Up2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:45:28 -0500
Date: Wed, 28 Jan 2015 18:09:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Omar Sandoval <osandov@osandov.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_acl: fix reference leaks in posix_acl_create
Message-ID: <20150128170952.GB17528@lst.de>
References: <0d8672e771b8fc1fef94db4b40b418afc8763c2b.1422338890.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d8672e771b8fc1fef94db4b40b418afc8763c2b.1422338890.git.osandov@osandov.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 10:16:53PM -0800, Omar Sandoval wrote:
> get_acl gets a reference which we must release in the error cases.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Looks good, but at this point goto-based unwinding might be in order.
