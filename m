Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaJ1Wyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:54:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46931 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaJ1Wy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:54:29 -0400
Date: Tue, 28 Oct 2014 22:54:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tim Tassonis <stuff@decentral.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: overlayfs: "filesystem of lowerdir is not supported" on cdrom
Message-ID: <20141028225428.GC7996@ZenIV.linux.org.uk>
References: <544FDC1C.9040908@decentral.ch>
 <20141028211313.GB7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028211313.GB7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:13:13PM +0000, Al Viro wrote:

> Documentation is wildly over-optimistic.  You are trying to use something
> with non-trivial ->d_hash and ->d_compare as lower layer.
> 
> What should happen if you ask to mount an image with joliet extensions and
> ask to create foo.txt.... when foo.txt is there?  From the isofs POV those
> are the same; for overlayfs they are not (it's using default ->d_hash
> and ->d_compare).
> 
> We probably ought to split the normal (case-sensitive, no joliet shite) case
> out and leave it with NULL ->s_d_op, but that'll need to be done carefully,
> or isofs_cmp() will blow up on us.

See if vfs.git#for-linus works for you.
