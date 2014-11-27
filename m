Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaK0Odp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:33:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaK0Odn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:33:43 -0500
Message-ID: <54773645.5010401@suse.cz>
Date: Thu, 27 Nov 2014 15:33:41 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: j.glisse@gmail.com
CC: linux-kernel@vger.kernel.org,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] scripts/package: binrpm-pkg do not build source tar file
References: <1414782331-7987-1-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1414782331-7987-1-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-31 20:05, j.glisse@gmail.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> When doing make binrpm-pkg we do not want to build the source tar
> file. This patch avoid doing the gigantic tar file.
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: linux-kbuild@vger.kernel.org
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
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

This does not generate any tar file, but a /usr/src/kernels/... tree to
be packaged in the kernel-devel package. I'm not says we should be doing
this in make binrpm-pkg, but the change should also remove the
kernel-devel package in the binrpm-pkg case.

Michal
