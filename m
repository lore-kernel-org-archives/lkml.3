Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaLDPFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:05:47 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:53546 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaLDPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:05:46 -0500
Date: Thu, 4 Dec 2014 10:05:37 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] scripts/package: binrpm-pkg do not create source and
 devel package v3
Message-ID: <20141204150534.GA2036@gmail.com>
References: <1417553159-11632-1-git-send-email-j.glisse@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417553159-11632-1-git-send-email-j.glisse@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 03:45:59PM -0500, j.glisse@gmail.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> When doing make binrpm-pkg we only want to build the binary and header
> package as the documentation of binrpm-pkg target claims. Hence this
> patch avoid building the source and devel package. This makes binrpm-pkg
> target lot faster and way more usefull.
> 
> Changed since v2 :
>   - Avoid symlinks in /usr/src/kernel.
>   - Update subject line and changelog.
> 
> Changed since v1 :
>   - Avoid building the devel package too.
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>

Drop your cc while updating commit log

> ---
>  scripts/package/mkspec | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/package/mkspec b/scripts/package/mkspec
> index 1395760..010653c 100755
> --- a/scripts/package/mkspec
> +++ b/scripts/package/mkspec
> @@ -119,11 +119,13 @@ echo "%endif"
>  
>  echo 'rm -f $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
>  echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
> +if ! $PREBUILT; then
>  echo "EXCLUDES=\"$RCS_TAR_IGNORE --exclude .tmp_versions --exclude=*vmlinux* --exclude=*.o --exclude=*.ko --exclude=*.cmd --exclude=Documentation --exclude=firmware --exclude .config.old --exclude .missing-syscalls.d\""
>  echo "tar "'$EXCLUDES'" -cf- . | (cd "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE;tar xvf -)"
>  echo 'cd $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE"
>  echo "ln -sf /usr/src/kernels/$KERNELRELEASE build"
>  echo "ln -sf /usr/src/kernels/$KERNELRELEASE source"
> +fi
>  
>  echo ""
>  echo "%clean"
> @@ -151,9 +153,11 @@ echo "%files headers"
>  echo '%defattr (-, root, root)'
>  echo "/usr/include"
>  echo ""
> +if ! $PREBUILT; then
>  echo "%files devel"
>  echo '%defattr (-, root, root)'
>  echo "/usr/src/kernels/$KERNELRELEASE"
>  echo "/lib/modules/$KERNELRELEASE/build"
>  echo "/lib/modules/$KERNELRELEASE/source"
>  echo ""
> +fi
> -- 
> 1.9.3
> 
