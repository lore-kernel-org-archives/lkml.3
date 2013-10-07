Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3JGVdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:33:42 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44784 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3JGVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <1378809966.26153.23.camel@cliu38-desktop-build>
References: <1378809966.26153.23.camel@cliu38-desktop-build>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Oct 2013 15:33:17 -0600
Message-ID: <CAErSpo7K9xfwnJW_=L=Oq9Dwe5sQc0879sEQuN2KeCMigPx5hw@mail.gmail.com>
Subject: Re: [PATCH] PCI/PM: Removing the function pci_pm_complete()
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fei.li@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 4:46 AM, Chuansheng Liu
<chuansheng.liu@intel.com> wrote:
>
> Commit(88d2613) removed the pm_runtime_put_sync() from pci_pm_complete()
> to PM core code device_complete().
>
> Here the pci_pm_complete() is doing the same work which can be done in
> device_complete(), so we can remove it directly.
>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Applied to pci/misc with Rafaels' ack, for v3.13.  Thanks!

Bjorn

> ---
>  drivers/pci/pci-driver.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 98f7b9b..736ef3f 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -599,18 +599,10 @@ static int pci_pm_prepare(struct device *dev)
>         return error;
>  }
>
> -static void pci_pm_complete(struct device *dev)
> -{
> -       struct device_driver *drv = dev->driver;
> -
> -       if (drv && drv->pm && drv->pm->complete)
> -               drv->pm->complete(dev);
> -}
>
>  #else /* !CONFIG_PM_SLEEP */
>
>  #define pci_pm_prepare NULL
> -#define pci_pm_complete        NULL
>
>  #endif /* !CONFIG_PM_SLEEP */
>
> @@ -1123,7 +1115,6 @@ static int pci_pm_runtime_idle(struct device *dev)
>
>  const struct dev_pm_ops pci_dev_pm_ops = {
>         .prepare = pci_pm_prepare,
> -       .complete = pci_pm_complete,
>         .suspend = pci_pm_suspend,
>         .resume = pci_pm_resume,
>         .freeze = pci_pm_freeze,
> --
> 1.7.0.4
>
>
>
