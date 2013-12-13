Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3LMQcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:32:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3LMQcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:32:14 -0500
Date: Fri, 13 Dec 2013 08:32:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: factor prid related codes into
 xfs_get_initial_prid()
Message-ID: <20131213163211.GD20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
 <1386944873-16796-2-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386944873-16796-2-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline prid_t xfs_get_initial_prid(struct xfs_inode *dp)
> +{
> +	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
> +		return xfs_get_projid(dp);
> +	else
> +		return XFS_PROJID_DEFAULT;
> +}

You could skip the else here.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
