Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3FGKud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:50:33 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37361 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGKuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <1370592580.3600.42.camel@kjgkr>
References: <1370584557-20592-1-git-send-email-jaegeuk.kim@samsung.com>
	<1370584557-20592-2-git-send-email-jaegeuk.kim@samsung.com>
	<1370592580.3600.42.camel@kjgkr>
Date: Fri, 7 Jun 2013 19:50:31 +0900
Message-ID: <CAKYAXd9V39ff3b3V13nOOH2nxZAMesMe9KzwUK-ovzBVUCkhGw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] f2fs: support xattr security labels
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/7, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Change log from v1:
>  o fix a bug
>
> From 901aea226653e26aa3556edd88ca1e48fa89eb5f Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Date: Mon, 3 Jun 2013 19:46:19 +0900
> Subject: [PATCH 2/2] f2fs: support xattr security labels
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
>
> This patch adds the support of security labels for f2fs, which will be used
> by SElinux.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/Kconfig |  9 +++++++++
>  fs/f2fs/dir.c   |  5 +++++
>  fs/f2fs/xattr.c | 60
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/f2fs/xattr.h | 12 +++++++++++-
>  4 files changed, 83 insertions(+), 3 deletions(-)
>
> diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
> index fd27e7e..2214cc9 100644
> --- a/fs/f2fs/Kconfig
> +++ b/fs/f2fs/Kconfig
> @@ -51,3 +51,12 @@ config F2FS_FS_POSIX_ACL
>  	  Linux website <http://acl.bestbits.at/>.
>
>  	  If you don't know what Access Control Lists are, say N
> +
> +config F2FS_FS_SECURITY
> +	bool "F2FS Security Labels"
> +	depends on F2FS_FS_XATTR
Hi Jaegeuk.
Do we need to add "default y" as other xattr options ?

Thanks.
> +	help
> +	  Security labels provide acls used by the security modules
> +	  like SELinux. This option should be used with the xattr mode.
> +
> +	  If you are not using a security module, say N.
