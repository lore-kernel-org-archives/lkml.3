Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaKHBd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:33:29 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:41788 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaKHBd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:33:28 -0500
Date: Fri, 7 Nov 2014 20:32:14 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] scripts/package: binrpm-pkg do not build source tar file
Message-ID: <20141108013208.GA5977@gmail.com>
References: <1414782331-7987-1-git-send-email-j.glisse@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414782331-7987-1-git-send-email-j.glisse@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 03:05:31PM -0400, j.glisse@gmail.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> When doing make binrpm-pkg we do not want to build the source tar
> file. This patch avoid doing the gigantic tar file.
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: linux-kbuild@vger.kernel.org
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Anyone ? Bueller ?

> ---
>  scripts/package/mkspec | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/package/mkspec b/scripts/package/mkspec
> index 1395760..b6f5e31 100755
> --- a/scripts/package/mkspec
> +++ b/scripts/package/mkspec
> @@ -119,8 +119,10 @@ echo "%endif"
>  
>  echo 'rm -f $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
>  echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
> +if ! $PREBUILT; then
>  echo "EXCLUDES=\"$RCS_TAR_IGNORE --exclude .tmp_versions --exclude=*vmlinux* --exclude=*.o --exclude=*.ko --exclude=*.cmd --exclude=Documentation --exclude=firmware --exclude .config.old --exclude .missing-syscalls.d\""
>  echo "tar "'$EXCLUDES'" -cf- . | (cd "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE;tar xvf -)"
> +fi
>  echo 'cd $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE"
>  echo "ln -sf /usr/src/kernels/$KERNELRELEASE build"
>  echo "ln -sf /usr/src/kernels/$KERNELRELEASE source"
> -- 
> 1.9.3
> 
