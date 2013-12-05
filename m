Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3LEJOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:14:42 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61821 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3LEJOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:14:38 -0500
MIME-Version: 1.0
In-Reply-To: <003701ceefb6$64918db0$2db4a910$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	<003701ceefb6$64918db0$2db4a910$%han@samsung.com>
Date: Thu, 5 Dec 2013 17:14:37 +0800
Message-ID: <CAAb+SYZ+891u6xAStg36mFa85YPNnrXJiVZUuQoupk5U+Brx+Q@mail.gmail.com>
Subject: Re: [PATCH 34/39] vme: remove DEFINE_PCI_DEVICE_TABLE macro
From: ZHAO Gang <gamerh2o@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 7:29 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

Greg, this patch should be reverted. It do the opposite things.

>  drivers/vme/boards/vme_vmivme7805.c |    2 +-
>  drivers/vme/bridges/vme_ca91cx42.c  |    2 +-
>  drivers/vme/bridges/vme_tsi148.c    |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vme/boards/vme_vmivme7805.c b/drivers/vme/boards/vme_vmivme7805.c
> index cf74aee..ac42212 100644
> --- a/drivers/vme/boards/vme_vmivme7805.c
> +++ b/drivers/vme/boards/vme_vmivme7805.c
> @@ -27,7 +27,7 @@ static void __iomem *vmic_base;
>
>  static const char driver_name[] = "vmivme_7805";
>
> -static DEFINE_PCI_DEVICE_TABLE(vmic_ids) = {
> +static const struct pci_device_id vmic_ids[] = {
>         { PCI_DEVICE(PCI_VENDOR_ID_VMIC, PCI_DEVICE_ID_VTIMR) },
>         { },
>  };
> diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
> index f844857..a06edbf 100644
> --- a/drivers/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/vme/bridges/vme_ca91cx42.c
> @@ -42,7 +42,7 @@ static int geoid;
>
>  static const char driver_name[] = "vme_ca91cx42";
>
> -static DEFINE_PCI_DEVICE_TABLE(ca91cx42_ids) = {
> +static const struct pci_device_id ca91cx42_ids[] = {
>         { PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_CA91C142) },
>         { },
>  };
> diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
> index 9cf8833..16830d8 100644
> --- a/drivers/vme/bridges/vme_tsi148.c
> +++ b/drivers/vme/bridges/vme_tsi148.c
> @@ -45,7 +45,7 @@ static int geoid;
>
>  static const char driver_name[] = "vme_tsi148";
>
> -static DEFINE_PCI_DEVICE_TABLE(tsi148_ids) = {
> +static const struct pci_device_id tsi148_ids[] = {
>         { PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_TSI148) },
>         { },
>  };
> --
> 1.7.10.4
>
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
