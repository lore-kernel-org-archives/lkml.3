Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3CSOgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:36:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33679 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab3CSOgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:36:48 -0400
Message-ID: <514877F1.8020204@ti.com>
Date: Tue, 19 Mar 2013 10:36:33 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/8] staging: [omap,ti-soc]-thermal: fixes and renaming
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,


On 18-03-2013 10:59, Eduardo Valentin wrote:
> Hi Greg,
>
> I am sending extra patches on omap-thermal driver, under staging.
>
> There are couple of fixes based on Dan Carpenter's review on
> the last patch set I sent. On top of these, there are some
> changes on the naming convention for this driver. This rename
> is based on previous review cycles that this driver has got.
> Besides, it must support other chip families, apart from OMAP,
> that's mainly why there is a big rename on this patch set.
> And as  usual, there are couple of extra fixes.

I am going to resend this series, dropping  patch 02 and splitting 
patch 04. It will also include extra fixes.


>
> All these are based on your staging/staging-next branch.
>
> For those interested in testing and trying the driver, these patches are
> also available, as usual, here:
> git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/ti-thermal-rename
> https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/omap/ti-thermal-rename
>
> BR,
>
> Eduardo Valentin (8):
>    staging: omap-thermal: fix return value
>    staging: omap-thermal: use spin_lock_irqsave inside IRQ handler
>    staging: omap-thermal: rename bg_ptr to bgp
>    staging: rename omap-thermal driver to ti-soc-thermal
>    staging: ti-soc-thermal: make unexported functions local
>    staging: ti-soc-thermal: split writable data from readonly data
>    stating: ti-soc-thermal: use sizeof(*pointer) while allocating
>    staging: ti-soc-thermal: fix several kernel-doc warnings and error
>
>   drivers/staging/Kconfig                            |    2 +-
>   drivers/staging/Makefile                           |    2 +-
>   drivers/staging/omap-thermal/Makefile              |    5 -
>   drivers/staging/omap-thermal/omap-bandgap.c        | 1300 --------------------
>   drivers/staging/omap-thermal/omap-thermal-common.c |  338 -----
>   .../{omap-thermal => ti-soc-thermal}/Kconfig       |   14 +-
>   drivers/staging/ti-soc-thermal/Makefile            |    5 +
>   .../staging/{omap-thermal => ti-soc-thermal}/TODO  |    0
>   .../omap4-thermal-data.c                           |   68 +-
>   .../omap4xxx-bandgap.h                             |    0
>   .../omap5-thermal-data.c                           |   20 +-
>   .../omap5xxx-bandgap.h                             |    0
>   .../omap_bandgap.txt                               |    0
>   drivers/staging/ti-soc-thermal/ti-bandgap.c        | 1299 +++++++++++++++++++
>   .../omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} |  181 ++--
>   drivers/staging/ti-soc-thermal/ti-thermal-common.c |  338 +++++
>   .../omap-thermal.h => ti-soc-thermal/ti-thermal.h} |   30 +-
>   17 files changed, 1803 insertions(+), 1799 deletions(-)
>   delete mode 100644 drivers/staging/omap-thermal/Makefile
>   delete mode 100644 drivers/staging/omap-thermal/omap-bandgap.c
>   delete mode 100644 drivers/staging/omap-thermal/omap-thermal-common.c
>   rename drivers/staging/{omap-thermal => ti-soc-thermal}/Kconfig (82%)
>   create mode 100644 drivers/staging/ti-soc-thermal/Makefile
>   rename drivers/staging/{omap-thermal => ti-soc-thermal}/TODO (100%)
>   rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4-thermal-data.c (85%)
>   rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4xxx-bandgap.h (100%)
>   rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5-thermal-data.c (96%)
>   rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5xxx-bandgap.h (100%)
>   rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap_bandgap.txt (100%)
>   create mode 100644 drivers/staging/ti-soc-thermal/ti-bandgap.c
>   rename drivers/staging/{omap-thermal/omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} (75%)
>   create mode 100644 drivers/staging/ti-soc-thermal/ti-thermal-common.c
>   rename drivers/staging/{omap-thermal/omap-thermal.h => ti-soc-thermal/ti-thermal.h} (72%)
>

