Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3LMQl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:41:56 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3LMQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:41:55 -0500
Date: Fri, 13 Dec 2013 08:41:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: allow linkat() on O_TMPFILE files
Message-ID: <20131213164154.GH20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
 <1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 10:27:53PM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Enable O_TMPFILE support in linkat().
> For more info, please refer to:
>   http://oss.sgi.com/archives/xfs/2013-08/msg00341.html

Generall you should provide all reasonable information in the changelog
instead of linking to it.

> +	if (sip->i_d.di_nlink == 0)
> +		tres = &M_RES(mp)->tr_link_tmpfile;
> +	else
> +		tres = &M_RES(mp)->tr_link;

As mentioned before I think Dave wanted you to always use the same
reservation, but I'll leave that discussion to him.

> +/* For creating a link to an O_TMPFILE inode, except modifying
> + * those metadata for regular inode, we still need to remove an inode
> + * from unlinked list at first. That is,  we can modify:
> + *    the agi hash list and counters: sector size
> + *    the on disk inode before ours in the agi hash list: inode cluster size
> + */

We always have an emptry content

/*

line at the beginning of comments in XFS and the Linux kernel in
general.

