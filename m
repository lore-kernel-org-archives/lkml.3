Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaJBGx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 02:53:56 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39540 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaJBGxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 02:53:55 -0400
Date: Thu, 2 Oct 2014 14:53:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] drivers: char: hw_random: printk replacement
Message-ID: <20141002065341.GA26145@gondor.apana.org.au>
References: <1410793281-30305-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410793281-30305-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 08:31:20PM +0530, Sudip Mukherjee wrote:
> as pr_* macros are more preffered over printk, so printk replaced with corresponding pr_* macros
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> The replacement was done by a bash script to avoid copy paste error. The script is as follows :
> 
> OLD="printk(KERN_ERR \?"
> OLD1="printk(KERN_NOTICE \?"
> OLD2="printk(KERN_WARNING \?"
> OLD3="printk(KERN_INFO \?"
> NEW="pr_err("
> NEW1="pr_notice("
> NEW2="pr_warn("
> NEW3="pr_info("
> TFILE="/tmp/out.tmp.$$"
> for f in *.c
> do
> sed -e "s/$OLD/$NEW/g" -e "s/$OLD1/$NEW1/g" -e "s/$OLD2/$NEW2/g" -e "s/$OLD3/$NEW3/g" "$f" > $TFILE && mv $TFILE "$f"
> done
> 
> exception is intel-rng.c . 
> in v1 the build failed due to intel-rng.c . 
> it has been corrected and has been carefully build tested.
> 
>  drivers/char/hw_random/amd-rng.c     |  4 ++--
>  drivers/char/hw_random/geode-rng.c   |  4 ++--
>  drivers/char/hw_random/intel-rng.c   | 13 ++++++-------
>  drivers/char/hw_random/pasemi-rng.c  |  2 +-
>  drivers/char/hw_random/pseries-rng.c |  2 +-
>  drivers/char/hw_random/via-rng.c     |  8 ++++----
>  6 files changed, 16 insertions(+), 17 deletions(-)

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
