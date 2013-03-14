Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab3CNBae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 21:30:34 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:57178 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3CNBac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 21:30:32 -0400
MIME-Version: 1.0
In-Reply-To: <1361761524-9495-1-git-send-email-wbin00@gmail.com>
References: <1361761524-9495-1-git-send-email-wbin00@gmail.com>
Date: Thu, 14 Mar 2013 09:30:32 +0800
Message-ID: <CAD_32VUREUgiBt2ScK31ig-p8282g7VZta+Q6Fq0pkEaDGxm+A@mail.gmail.com>
Subject: Re: [PATCH 1/1] scripts/package/Makefile: compare objtree with
 srctree instead of test KBUILD_OUTPUT
From: Bin Wang <wbin00@gmail.com>
To: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Michal

Is there any comments on this?

2013/2/25 Bin Wang <wbin00@gmail.com>:
> KBUILD_OUTPUT is always empty here, so it is useless to test it. But
> while use O=.., objtree and srctree will be different. I compare them
> instead.
>
> Signed-off-by: Bin Wang <wbin00@gmail.com>
> ---
>  scripts/package/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> index 87bf080..d7b3285 100644
> --- a/scripts/package/Makefile
> +++ b/scripts/package/Makefile
> @@ -36,7 +36,7 @@ $(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
>         $(CONFIG_SHELL) $(MKSPEC) > $@
>
>  rpm-pkg rpm: $(objtree)/kernel.spec FORCE
> -       @if test -n "$(KBUILD_OUTPUT)"; then \
> +       @if test "$(objtree)" != "$(srctree)"; then \
>                 echo "Building source + binary RPM is not possible outside the"; \
>                 echo "kernel source tree. Don't set KBUILD_OUTPUT, or use the"; \
>                 echo "binrpm-pkg target instead."; \
> --
> 1.8.1.4
>
