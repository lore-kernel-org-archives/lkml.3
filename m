Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaCKGi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:38:29 -0400
Received: from gproxy1-pub.mail.unifiedlayer.com ([69.89.25.95]:32855 "HELO
	gproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751649AbaCKGi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:38:27 -0400
X-Authority-Analysis: v=2.1 cv=Ht/lRSjS c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=SQyqtliOqU0A:10 a=neHJxMmKCwgA:10 a=IkcTkHD0fZMA:10
 a=wCmvBT1CAAAA:8 a=djd9j7hWnewA:10 a=9jOhWAhXBOej48W-URoA:9 a=QEXdDO2ut3YA:10
 a=8HaUlT0CE8IA:10
Message-ID: <1394519888.2191.1.camel@slavad-CELSIUS-H720>
Subject: Re: [PATCH 1/1] HFSPLUS: add __init to
 hfsplus_create_attr_tree_cache()
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Date: Tue, 11 Mar 2014 10:38:08 +0400
In-Reply-To: <20140310215658.965a9750989dc3866713afd0@skynet.be>
References: <20140310215658.965a9750989dc3866713afd0@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.92 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 21:56 +0100, Fabian Frederick wrote:
> hfsplus_create_attr_tree_cache is only called by __init init_hfsplus_fs
> 

I think that it is the reasonable fix. Looks good for me.

Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Vyacheslav Dubeyko.

> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/hfsplus/attributes.c | 2 +-
>  fs/hfsplus/hfsplus_fs.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/hfsplus/attributes.c b/fs/hfsplus/attributes.c
> index 0f47890..caf89a7 100644
> --- a/fs/hfsplus/attributes.c
> +++ b/fs/hfsplus/attributes.c
> @@ -11,7 +11,7 @@
>  
>  static struct kmem_cache *hfsplus_attr_tree_cachep;
>  
> -int hfsplus_create_attr_tree_cache(void)
> +int __init hfsplus_create_attr_tree_cache(void)
>  {
>  	if (hfsplus_attr_tree_cachep)
>  		return -EEXIST;
> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index 08846425b..bb75586 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -366,7 +366,7 @@ typedef int (*search_strategy_t)(struct hfs_bnode *,
>   */
>  
>  /* attributes.c */
> -int hfsplus_create_attr_tree_cache(void);
> +int __init hfsplus_create_attr_tree_cache(void);
>  void hfsplus_destroy_attr_tree_cache(void);
>  hfsplus_attr_entry *hfsplus_alloc_attr_entry(void);
>  void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry_p);


