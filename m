Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaLBQGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:06:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbaLBQGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:06:47 -0500
Message-ID: <547DE395.509@suse.cz>
Date: Tue, 02 Dec 2014 17:06:45 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: j.glisse@gmail.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/package: binrpm-pkg do not build source tar file
 v2
References: <1417467438-32001-1-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1417467438-32001-1-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-01 21:57, j.glisse@gmail.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> When doing make binrpm-pkg we do not want to build the source tar
> file. This patch avoid doing the gigantic tar file.

Can you also update the changelog and subject? There is no gigantic tar
file.


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

The /usr/src/kernels/... directory and the build and source symlinks are
not needed either, if we are not building the -devel package.

Michal
