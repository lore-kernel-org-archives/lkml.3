Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934421Ab3DGWAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:00:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60642 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758412Ab3DGWAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:00:20 -0400
Message-ID: <1365372019.8922.17.camel@joe-AO722>
Subject: Re: [PATCH 2/2] hfsplus: add printk to log allocation failure in
 hfs_find_init()
From: Joe Perches <joe@perches.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Date: Sun, 07 Apr 2013 15:00:19 -0700
In-Reply-To: <1365369695-8340-2-git-send-email-khoroshilov@ispras.ru>
References: <0199BA74-9971-4928-A133-DB1FC562DC43@dubeyko.com>
	 <1365369695-8340-1-git-send-email-khoroshilov@ispras.ru>
	 <1365369695-8340-2-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 01:21 +0400, Alexey Khoroshilov wrote:
> Add printk to log allocation failure in hfs_find_init(),
> "so that there is a sign in dmesg when the error condition is triggered".
> (per Hin-Tak Leung request)

Not needed.  There already is a generic dump_stack
on all allocation failures without __GFP_NOWARN.

> diff --git a/fs/hfsplus/bfind.c b/fs/hfsplus/bfind.c
[]
> @@ -18,8 +18,10 @@ int hfs_find_init(struct hfs_btree *tree, struct hfs_find_data *fd)

> +	if (!ptr) {
> +		printk(KERN_ERR "hfs: allocation failed in hfs_find_init()\n");
>  		return -ENOMEM;


