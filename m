Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaGMV0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:26:19 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:34282 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaGMV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:26:13 -0400
Date: Sun, 13 Jul 2014 23:26:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Marek <mmarek@suse.cz>, David Woodhouse <dwmw2@infradead.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCHv1 2/2] Documentation/kbuild/headers_install.txt: update
 documentation
Message-ID: <20140713212608.GB16496@ravnborg.org>
References: <20140709204915.GB32335@ravnborg.org>
 <cover.1405246007.git.ydroneaud@opteya.com>
 <3e0d73d0ca3ead75624b552105ce8adf3d63684e.1405246009.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e0d73d0ca3ead75624b552105ce8adf3d63684e.1405246009.git.ydroneaud@opteya.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 12:15:30PM +0200, Yann Droneaud wrote:
> Documentation in kbuild/headers_install.txt is not
> up to date regarding:
> - way to list the various architectures;
> - path where the headers are installed.
> 
> This patch try to fix these issues.
> 
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Rob Landley <rob@landley.net>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
>  Documentation/kbuild/headers_install.txt | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
> index 951eb9f1e040..8b6751f10dd3 100644
> --- a/Documentation/kbuild/headers_install.txt
> +++ b/Documentation/kbuild/headers_install.txt
> @@ -24,23 +24,24 @@ The "make headers_install" command can be run in the top level directory of the
>  kernel source code (or using a standard out-of-tree build).  It takes two
>  optional arguments:
>  
> -  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
> +  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr
OK

>  

> to see a list of supported architectures use
>  the command:
>  
> -  ls -d include/asm-* | sed 's/.*-//'
> +  /bin/ls -1 arch/*/include/asm/Kbuild | sed -e 's,^arch/,,' \
> +                                             -e 's,/include/asm/Kbuild$,,'
This information is nor relevant these days as all architectures support exporting userspace headers.
So drop this part of the documentation.
cris is broken - I will send a patch to fix this.
In reality um does not support exporting headers - but it makes no sense either.
We do not want to do anything special just to mention that um is not included.

>  The command "make headers_install_all" exports headers for all architectures
>  simultaneously.  (This is mostly of interest to distribution maintainers,
>  who create an architecture-independent tarball from the resulting include
>  directory.)
I have seriously considered dropping the "headers_install_all" target.
It does not make any sense as some files are optional for the individual archs
and only pure luck will define if the relevant fiels are included or not.

We would still like the "headers_check_all" feature but this is better done in
a small shell script than as it is today where we need special handling
to support it in Makefile.headersinst - and it adds complexity
to the top-level Makefile which we shall avoid.
But this is unrelated to your documentation clean-up.

	Sam
