Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbaCUOGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:06:55 -0400
Received: from eso.teric.us ([69.164.192.171]:38656 "EHLO eso.teric.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbaCUOGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:06:52 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2014 10:06:52 EDT
Date: Fri, 21 Mar 2014 09:01:33 -0500
From: Josh Cartwright <joshc@eso.teric.us>
To: Matei Oprea <eu@opreamatei.ro>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: Re: [PATCH] drivers: staging: cxt1e1: hwprobe Fix different address
 spaces
Message-ID: <20140321140133.GS25913@kryptos>
References: <1395409943-19023-1-git-send-email-eu@opreamatei.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395409943-19023-1-git-send-email-eu@opreamatei.ro>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 03:52:23PM +0200, Matei Oprea wrote:
> Fix different address spaces when unmapping IO. hi->addr_mapped[0]
> and hi->addr_mapped[1] should be tagged __iomem.
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/staging/cxt1e1/hwprobe.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
> index 9b4198b..f55c27e 100644
> --- a/drivers/staging/cxt1e1/hwprobe.c
> +++ b/drivers/staging/cxt1e1/hwprobe.c
> @@ -174,12 +174,12 @@ cleanup_ioremap(void)
>  		if (hi->pci_slot == 0xff)
>  			break;
>  		if (hi->addr_mapped[0]) {
> -			iounmap((void *)(hi->addr_mapped[0]));
> +			iounmap((void __iomem *)(hi->addr_mapped[0]));

While this may "fix" the sparse warning, it's far from ideal.  Like I
had suggested on IRC, a much better cleanup would be to make the
addr_mapped member an array of __iomem-tagged pointers, and fixup the
users.

  Josh
