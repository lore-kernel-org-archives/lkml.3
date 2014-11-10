Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaKJOCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:02:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:55960 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbaKJOCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:02:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,353,1413270000"; 
   d="scan'208";a="619965492"
Message-ID: <1415628106.22887.122.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/4] UBIFS: Add xattr support for symlinks
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Mon, 10 Nov 2014 16:01:46 +0200
In-Reply-To: <1414781431-2911-3-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
	 <1414781431-2911-3-git-send-email-ben.shelton@ni.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 13:50 -0500, Ben Shelton wrote:
> From: Subodh Nijsure <snijsure@grid-net.com>
> 
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Ben Shelton <ben.shelton@ni.com>
> Acked-by: Terry Wilcox <terry.wilcox@ni.com>
> Acked-by: Gratian Crisan <gratian.crisan@ni.com>
> ---
>  fs/ubifs/file.c  |  4 ++++
>  fs/ubifs/xattr.c | 17 ++++++++++++-----
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index b5b593c..4a1d4cf 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1573,6 +1573,10 @@ const struct inode_operations ubifs_symlink_inode_operations = {
>  	.follow_link = ubifs_follow_link,
>  	.setattr     = ubifs_setattr,
>  	.getattr     = ubifs_getattr,
> +	.setxattr    = ubifs_setxattr,
> +	.getxattr    = ubifs_getxattr,
> +	.listxattr   = ubifs_listxattr,
> +	.removexattr = ubifs_removexattr,

Could you please re-test this with any kernel and carefully verify
symlinks. I think this should not work, because in case of symlinks we
already store the link target path in the inode, and with this patch the
target patch will be over-written with the SELinux label. I expect this
to be seen easily on testing - symlink targets should be corrupted.

Artem.


