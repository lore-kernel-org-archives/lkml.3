Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3IEERj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:17:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58879 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753484Ab3IEERh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:17:37 -0400
Message-ID: <1378354654.1787.70.camel@joe-AO722>
Subject: Re: [PATCH] Fix missing braces in ncpfs:ncp_lookup
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        Petr Vandrovec <petr@vandrovec.name>
Date: Wed, 04 Sep 2013 21:17:34 -0700
In-Reply-To: <20130905040418.GA20210@redhat.com>
References: <20130905040418.GA20210@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Petr Vandrovec to cc's)

> diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
[]
> @@ -857,10 +857,11 @@ static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, unsig
>  	if (ncp_is_server_root(dir)) {
>  		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
>  				 dentry->d_name.len, 1);
> -		if (!res)
> +		if (!res) {
>  			res = ncp_lookup_volume(server, __name, &(finfo.i));
>  			if (!res)
>  				ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
> +		}
                                


