Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3LSSO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:14:59 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:62777 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3LSSO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:14:56 -0500
MIME-Version: 1.0
In-Reply-To: <8b3e7f6a5ffdf104e316c5e1c848d7db34dd766e.1387387468.git.rashika.kheria@gmail.com>
References: <7fc39fa8a73bfcca6f379c6cd53cdb1659fc9d12.1387387468.git.rashika.kheria@gmail.com>
 <8b3e7f6a5ffdf104e316c5e1c848d7db34dd766e.1387387468.git.rashika.kheria@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 Dec 2013 11:14:35 -0700
Message-ID: <CAErSpo6sbrYa_xLrxpWp8X8mTjEpGxAQGrvG3gEt5h=EnMs0ww@mail.gmail.com>
Subject: Re: [PATCH 3/3] drivers: pcmcia: Include appropriate header file in cardbus.c
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-pcmcia@lists.infradead.org,
        josh@joshtriplett.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 1:36 AM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:
> Include appropriate header file cs_internal.h in cardbus.c because
> functions cb_alloc() and cb_free() have their prototype declarations in
> cs_internal.h.
>
> This eliminates the following warnings in cardbus.c:
> drivers/pcmcia/cardbus.c:67:11: warning: no previous prototype for ‘cb_alloc’ [-Wmissing-prototypes]
> drivers/pcmcia/cardbus.c:105:6: warning: no previous prototype for ‘cb_free’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied to my pci/misc branch for v3.14, thanks!

Bjorn

> ---
>  drivers/pcmcia/cardbus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
> index b2a98cd..1c85f4b 100644
> --- a/drivers/pcmcia/cardbus.c
> +++ b/drivers/pcmcia/cardbus.c
> @@ -25,7 +25,7 @@
>  #include <linux/pci.h>
>
>  #include <pcmcia/ss.h>
> -
> +#include "cs_internal.h"
>
>  static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
>  {
> --
> 1.7.9.5
>
