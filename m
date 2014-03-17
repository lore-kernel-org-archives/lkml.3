Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaCQTT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbaCQTTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:19:23 -0400
Message-ID: <53274A91.8020809@redhat.com>
Date: Mon, 17 Mar 2014 20:18:41 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>
CC: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-@jasper.es
Subject: Re: [PATCH 0/4] ata: add remaining new-style AHCI platform drivers
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/17/2014 07:31 PM, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This patch series adds new-style AHCI platform drivers for DaVinci DA850
> AHCI controller and ST SPEAr1340 AHCI controller.  As a preparation for
> adding these drivers it also fixes ahci_platform_data->suspend() handling
> (patch #1) and moves library AHCI platform code to its own file (patch #2).
> The new AHCI platform drivers are only compile tested (they are marked as
> experimental because of this) and I would ask somebody with the hardware
> to verify them (thanks!).

Thanks for working on this.

Patches 1/2 seem sensible to me, and 3/4 are obviously a good idea. Also
all patches look good to me, so this series is:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
> Bartlomiej Zolnierkiewicz (4):
>   ata: ahci_platform: fix ahci_platform_data->suspend method handling
>   ata: move library code from ahci_platform.c to libahci_platform.c
>   ata: add new-style AHCI platform driver for DaVinci DA850 AHCI
>     controller
>   ata: add new-style AHCI platform driver for ST SPEAr1340 AHCI
>     controller
> 
>  drivers/ata/Kconfig            |  23 +-
>  drivers/ata/Makefile           |  10 +-
>  drivers/ata/ahci_da850.c       | 178 ++++++++++++++
>  drivers/ata/ahci_platform.c    | 508 --------------------------------------
>  drivers/ata/ahci_spear1340.c   | 222 +++++++++++++++++
>  drivers/ata/libahci_platform.c | 541 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 967 insertions(+), 515 deletions(-)
>  create mode 100644 drivers/ata/ahci_da850.c
>  create mode 100644 drivers/ata/ahci_spear1340.c
>  create mode 100644 drivers/ata/libahci_platform.c
> 
