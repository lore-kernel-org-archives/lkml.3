Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab3EOKIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab3EOKH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 06:07:58 -0400
Subject: Re: [PATCH -next] gfs2: fix DLM depends to fix build errors
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Teigland <teigland@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <51926E38.7090801@infradead.org>
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
	 <518A93BD.3020300@infradead.org>
	 <20130509094745.049e46fff25f357e7eb50123@canb.auug.org.au>
	 <20130509165028.GA18077@redhat.com>  <518BD826.4040403@infradead.org>
	 <1368436712.2882.14.camel@menhir> <5191153F.8000001@infradead.org>
	 <51913F8B.7080201@infradead.org> <51914045.1060900@infradead.org>
	 <519142E7.4080009@infradead.org> <1368521520.2711.1.camel@menhir>
	 <51926E38.7090801@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 15 May 2013 11:05:06 +0100
Message-ID: <1368612306.2732.16.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the -nmw tree. Will push to -fixes once it has had a few days to
sit in -nmw/-next. Thanks,

Steve.

On Tue, 2013-05-14 at 10:02 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors by correcting DLM dependencies in GFS2.
> Build errors happen when CONFIG_GFS2_FS_LOCKING_DLM=y and CONFIG_DLM=m:
> 
> fs/built-in.o: In function `gfs2_lock':
> file.c:(.text+0xc7abd): undefined reference to `dlm_posix_get'
> file.c:(.text+0xc7ad0): undefined reference to `dlm_posix_unlock'
> file.c:(.text+0xc7ad9): undefined reference to `dlm_posix_lock'
> fs/built-in.o: In function `gdlm_unmount':
> lock_dlm.c:(.text+0xd6e5b): undefined reference to `dlm_release_lockspace'
> fs/built-in.o: In function `sync_unlock':
> lock_dlm.c:(.text+0xd6e9e): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `sync_lock':
> lock_dlm.c:(.text+0xd6fb6): undefined reference to `dlm_lock'
> fs/built-in.o: In function `gdlm_put_lock':
> lock_dlm.c:(.text+0xd7238): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `gdlm_mount':
> lock_dlm.c:(.text+0xd753e): undefined reference to `dlm_new_lockspace'
> lock_dlm.c:(.text+0xd79d3): undefined reference to `dlm_release_lockspace'
> fs/built-in.o: In function `gdlm_lock':
> lock_dlm.c:(.text+0xd8179): undefined reference to `dlm_lock'
> fs/built-in.o: In function `gdlm_cancel':
> lock_dlm.c:(.text+0xd6b22): undefined reference to `dlm_unlock'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  fs/gfs2/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20130513.orig/fs/gfs2/Kconfig
> +++ linux-next-20130513/fs/gfs2/Kconfig
> @@ -26,7 +26,7 @@ config GFS2_FS
>  config GFS2_FS_LOCKING_DLM
>  	bool "GFS2 DLM locking"
>  	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
> -		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
> +		HOTPLUG && CONFIGFS_FS && SYSFS && (DLM=y || DLM=GFS2_FS)
>  	help
>  	  Multiple node locking module for GFS2
>  


