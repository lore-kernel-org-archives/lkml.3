Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3LKCbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:31:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3LKCbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:31:10 -0500
Date: Tue, 10 Dec 2013 18:32:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lai Siyao <laisiyao@whamcloud.com>,
        Lai Siyao <lai.siyao@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 06/13] staging/lustre/llite: remove ll_d_root_ops
Message-ID: <20131211023238.GA10365@kroah.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
 <1386601025-422-7-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386601025-422-7-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:56:58PM +0800, Peng Tao wrote:
> From: Lai Siyao <laisiyao@whamcloud.com>
> 
> Mnt root dentry will never be revalidated, but its d_op->d_compare
> will be called for its children, to simplify code, we use the same
> ll_d_ops as normal dentries.
> But its attribute may be invalid before access, this won't cause
> any issue because it always exists, and the only operation depends
> on its attribute is .permission, which has revalidated it in lustre
> code.
> 
> So it's okay to remove ll_d_root_ops, and remove unnecessary checks
> in lookup/revalidate/statahead.

This breaks the build.

It's as if you aren't testing this.

I'm really tired of this, I really don't want to take any more patches
from you for a while, as I dread them every time I see a series sent by
you for this codebase.

ugh.
