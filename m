Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaHSOCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:02:51 -0400
Received: from ozlabs.org ([103.22.144.67]:46881 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbaHSOCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:02:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Bertrand Jacquin <beber@meleeweb.net>, linux-kbuild@vger.kernel.org
Cc: Bertrand Jacquin <beber@meleeweb.net>, linux-kernel@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>
Cc: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 3/3] modsign: lookup lines ending in .ko in .mod files
In-Reply-To: <1408215016-1848-4-git-send-email-beber@meleeweb.net>
References: <1408215016-1848-1-git-send-email-beber@meleeweb.net> <1408215016-1848-4-git-send-email-beber@meleeweb.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 19 Aug 2014 06:30:10 +0930
Message-ID: <8761hp8qed.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bertrand Jacquin <beber@meleeweb.net> writes:
> This does the same as commit ef591a5 (scripts/Makefile.modpost: error
> in finding modules from .mod files), but for scripts/Makefile.modsign
>
> Maybe we should also apply to Makefile.modsign and Makefile.modinst
> the change applied to Makefile.modpost by commit ea4054a (modpost:
> handle huge numbers of modules) ?

Good question.  David Woodhose cc'd...

Cheers,
Rusty.

> Reviewed-by: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Bertrand Jacquin <beber@meleeweb.net>
> ---
>  scripts/Makefile.modsign | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.modsign b/scripts/Makefile.modsign
> index abfda62..b6ac708 100644
> --- a/scripts/Makefile.modsign
> +++ b/scripts/Makefile.modsign
> @@ -7,7 +7,7 @@ __modsign:
>  
>  include scripts/Kbuild.include
>  
> -__modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
> +__modules := $(sort $(shell grep -h '\.ko$$' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
>  modules := $(patsubst %.o,%.ko,$(wildcard $(__modules:.ko=.o)))
>  
>  PHONY += $(modules)
> -- 
> 2.0.4
