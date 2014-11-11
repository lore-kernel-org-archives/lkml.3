Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaKKLkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:40:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:11483 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbaKKLKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="486464503"
Message-ID: <1415704235.22887.138.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] UBIFS: add ubifs_err() to print error reason
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 11 Nov 2014 13:10:35 +0200
In-Reply-To: <1414781431-2911-5-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
	 <1414781431-2911-5-git-send-email-ben.shelton@ni.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pushed this, but made some amendments.

Now all 4 are in the master branch. Would you please re-test them again
and confirm that they are fine. Then I'll push them to the linux-next
branch, unless you report that my amendments broke something.

Thank you!

On Fri, 2014-10-31 at 13:50 -0500, Ben Shelton wrote:
> @@ -100,24 +100,32 @@ static const struct file_operations empty_fops;
>  static int create_xattr(struct ubifs_info *c, struct inode *host,
>  			const struct qstr *nm, const void *value, int size)
>  {
> -	int err;
> +	int err, xattr_name_list_size;

Renamed this to a shorter names_len.

> -	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE)
> +	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE) {
> +		ubifs_err("ubifs xattr_cnt %d exceeds MAX_XATTR_PER_NODE (%d)",
> +			  host_ui->xattr_cnt, MAX_XATTRS_PER_INODE);

Improved this message - made it more user-friendly, and print the inode
number.

> +	if (xattr_name_list_size > XATTR_LIST_MAX) {
> +		ubifs_err("xattr name list too large %d > %d",
> +			  xattr_name_list_size, XATTR_LIST_MAX);
>  		return -ENOSPC;

Ditto.
>  
> +	if (err)
> +		ubifs_err("cannot initialize extended attribute, error %d",
> +			  err);

Refactored this message and added the inode number.

Artem.

