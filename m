Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807Ab3DHGIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:08:47 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:34196 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753646Ab3DHGIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:08:45 -0400
Message-ID: <1365401315.2673.11.camel@slavad-ubuntu>
Subject: Re: [PATCH 2/2] hfsplus: add printk to log allocation failure in
 hfs_find_init()
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Joe Perches <joe@perches.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Date: Mon, 08 Apr 2013 10:08:35 +0400
In-Reply-To: <1365372019.8922.17.camel@joe-AO722>
References: <0199BA74-9971-4928-A133-DB1FC562DC43@dubeyko.com>
	 <1365369695-8340-1-git-send-email-khoroshilov@ispras.ru>
	 <1365369695-8340-2-git-send-email-khoroshilov@ispras.ru>
	 <1365372019.8922.17.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.124.66 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-04-07 at 15:00 -0700, Joe Perches wrote:
> On Mon, 2013-04-08 at 01:21 +0400, Alexey Khoroshilov wrote:
> > Add printk to log allocation failure in hfs_find_init(),
> > "so that there is a sign in dmesg when the error condition is triggered".
> > (per Hin-Tak Leung request)
> 
> Not needed.  There already is a generic dump_stack
> on all allocation failures without __GFP_NOWARN.
> 

I agree too.

Moreover, Hin-Tak asks about dprint() but not printk(). The dprint()
messages can be useful for debugging purposes and will be disabled for
usual kernel build.

I think that adding dprint() messages in hfs_find_init() is not
necessary. But adding dprint() for __hfsplus_ext_write_extent() and
other places can be useful, from my point of view. And such messages can
be useful as for HFS+ as for HFS drivers.

With the best regards,
Vyacheslav Dubeyko.

> > diff --git a/fs/hfsplus/bfind.c b/fs/hfsplus/bfind.c
> []
> > @@ -18,8 +18,10 @@ int hfs_find_init(struct hfs_btree *tree, struct hfs_find_data *fd)
> 
> > +	if (!ptr) {
> > +		printk(KERN_ERR "hfs: allocation failed in hfs_find_init()\n");
> >  		return -ENOMEM;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


