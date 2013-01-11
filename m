Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3AKRkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:40:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38864 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3AKRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:40:06 -0500
Date: Fri, 11 Jan 2013 12:39:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tamas Lengyel <tamas.lengyel@zentific.com>
Cc: jeremy@goop.org, Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Access control in Xen privcmd_ioctl_mmap
Message-ID: <20130111173954.GC26287@phenom.dumpdata.com>
References: <CAErYnsgFhW3Cf-W1CQJGOUstcyfdQxWUcGkGbd0uxM1R=XYuSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErYnsgFhW3Cf-W1CQJGOUstcyfdQxWUcGkGbd0uxM1R=XYuSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 03:44:30PM -0500, Tamas Lengyel wrote:
> In the privcmd Linux driver two checks in the functions
> privcmd_ioctl_mmap and privcmd_ioctl_mmap_batch are not needed as they
> are trying to enforce hypervisor-level access control.  They should be
> removed as they break secondary control domains when performing dom0
> disaggregation. Xen itself provides adequate security controls around
> these hypercalls and these checks prevent those controls from
> functioning as intended.
> 
> The patch applies to the stable Linux 3.7.1 kernel.

Hm, I get this:

atching file drivers/xen/privcmd.c
Hunk #1 FAILED at 196.
patch: **** malformed patch at line 91: *udata, int version)

Anyhow I fixed it up.

Should this patch also be back-ported to the stable trees?

> 
> Signed-off-by: Tamas K Lengyel <tamas.lengyel@zentific.com>
> Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Cc: xen-devel@lists.xensource.com
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/xen/privcmd.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index 71f5c45..adaa260 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -196,9 +196,6 @@ static long privcmd_ioctl_mmap(void __user *udata)
>         LIST_HEAD(pagelist);
>         struct mmap_mfn_state state;
> 
> -       if (!xen_initial_domain())
> -               return -EPERM;
> -
>         if (copy_from_user(&mmapcmd, udata, sizeof(mmapcmd)))
>                 return -EFAULT;
> 
> @@ -316,9 +313,6 @@ static long privcmd_ioctl_mmap_batch(void __user
> *udata, int version)
>         int *err_array = NULL;
>         struct mmap_batch_state state;
> 
> -       if (!xen_initial_domain())
> -               return -EPERM;
> -
>         switch (version) {
>         case 1:
>                 if (copy_from_user(&m, udata, sizeof(struct privcmd_mmapbatch)))
