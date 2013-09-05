Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3IEE3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:29:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3IEE3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:29:18 -0400
Date: Thu, 5 Sep 2013 05:29:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix missing braces in ncpfs:ncp_lookup
Message-ID: <20130905042916.GO13318@ZenIV.linux.org.uk>
References: <20130905040418.GA20210@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905040418.GA20210@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 12:04:18AM -0400, Dave Jones wrote:
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
> index 3be0474..1f6419f 100644
> --- a/fs/ncpfs/dir.c
> +++ b/fs/ncpfs/dir.c
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

That, or shift two lines one indent level out ;-)  I mean,
	if (!foo)
		foo = bar();
	if (!foo)
		baz();
is provably equivalent to
	if (!foo) {
		foo = bar();
		if (!foo)
			baz();
	}

I agree that the current form shouldn't be left as-is - the kernel isn't
IOCCC and all such.  The only question is which variant would read better...
