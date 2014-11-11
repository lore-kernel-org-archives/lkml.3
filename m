Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaKKLHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:07:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:29961 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbaKKLHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:07:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="620494694"
Message-ID: <1415704063.22887.135.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBIFS: Add security.* XATTR support for the UBIFS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 11 Nov 2014 13:07:43 +0200
In-Reply-To: <1414781431-2911-4-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
	 <1414781431-2911-4-git-send-email-ben.shelton@ni.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

pushed this patch too, with amendments.

On Fri, 2014-10-31 at 13:50 -0500, Ben Shelton wrote:
> @@ -279,6 +283,7 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0, 0);
>  	if (err)
>  		goto out_cancel;
> +
>  	mutex_unlock(&dir_ui->ui_mutex);

Removed this junk newline change here and in other similar places.
> +size_t ubifs_security_listxattr(struct dentry *d, char *list, size_t list_size,
> +				const char *name, size_t name_len, int flags)

Made this to be static, renamed to 'security_listxattr()'.

> +int ubifs_security_getxattr(struct dentry *d, const char *name,
> +			    void *buffer, size_t size, int flags)

Similar: rename + static.

> +int ubifs_security_setxattr(struct dentry *d, const char *name,
> +			    const void *value, size_t size,
> +			    int flags, int handler_flags)
Similar: rename + static.

> +struct xattr_handler ubifs_xattr_security_handler = {

Renamed, made static and const too.

> +static int ubifs_initxattrs(struct inode *inode,
> +			    const struct xattr *xattr_array, void *fs_info)

Renamed to just init_xattrs(), for the consistency reasons, the ones I
explained in the review to the patch 2/4.

