Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaIRAYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:24:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:32809 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbaIRAYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:24:01 -0400
Message-ID: <541A261B.90208@infradead.org>
Date: Wed, 17 Sep 2014 17:23:55 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
CC: sfr@canb.auug.org.au
Subject: Re: [PATCH] Documentation: disable vdso_test to avoid breakage with
 old glibc
References: <1410912565-26085-1-git-send-email-pefoley2@pefoley.com>
In-Reply-To: <1410912565-26085-1-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/14 17:09, Peter Foley wrote:
> glibc versions older than 2.16 don't include sys/auxv.h which this
> executable uses.
> Since we don't have a good way to test for specific glibc versions in
> kbuild, just disable it for now.
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>

Applied.  Thanks.

> ---
>  Documentation/vDSO/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
> index d87bb29..2b99e57 100644
> --- a/Documentation/vDSO/Makefile
> +++ b/Documentation/vDSO/Makefile
> @@ -1,5 +1,5 @@
> -# List of programs to build
> -hostprogs-y := vdso_test
> +# vdso_test won't build for glibc < 2.16, so disable it
> +# hostprogs-y := vdso_test
>  hostprogs-$(CONFIG_X86) := vdso_standalone_test_x86
>  vdso_standalone_test_x86-objs := vdso_standalone_test_x86.o parse_vdso.o
>  vdso_test-objs := parse_vdso.o vdso_test.o
> 


-- 
~Randy
