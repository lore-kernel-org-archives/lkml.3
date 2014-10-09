Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaJIIo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:44:58 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61207 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJIIoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <1412051169-9142-1-git-send-email-ankit.jindal@linaro.org>
References: <1412051169-9142-1-git-send-email-ankit.jindal@linaro.org>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Thu, 9 Oct 2014 14:14:33 +0530
Message-ID: <CAPTm99V-xyXa7WQG2jzDz19gotJ0aQRPk_rb5ukvUpdFyFabfw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] UIO driver for APM X-Gene QMTM
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ankit Jindal <ankit.jindal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this patch set.

Thanks,
Ankit

On 30 September 2014 09:56, Ankit Jindal <ankit.jindal@linaro.org> wrote:
> This patchset enables user space access to APM X-Gene QMTM
> using UIO framework.
>
> The patchset also introduces new type UIO_MEM_PHYS_CACHE
> for mem regions because APM X-Gene QMTM device supports
> cache coherency with CPU caches.
>
> Changes since v1:
>  - Factor-out formating related change in uio/uio.c as separate patch.
>  - Use devm_xxx() APIs where appilicable.
>  - Some cleanups and buggy loop fixed in qmtm_reset().
>  - Removed open and release functions.
>  - Use phandle for specifying QMTM qpool resource.
>  - Removed "uio" from the compatible string.
>  - Added more information about QMTM in binding documentation.
>
> Ankit Jindal (6):
>   uio: code style cleanup
>   uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
>   Documentation: Update documentation for UIO_MEM_PHYS_CACHE
>   drivers: uio: Add X-Gene QMTM UIO driver
>   Documentation: dt-bindings: Add binding info for X-Gene QMTM UIO
>     driver
>   MAINTAINERS: Add entry for APM X-Gene QMTM UIO driver
>
>  Documentation/DocBook/uio-howto.tmpl               |    5 +-
>  .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   53 ++++
>  MAINTAINERS                                        |    7 +
>  drivers/uio/Kconfig                                |    8 +
>  drivers/uio/Makefile                               |    1 +
>  drivers/uio/uio.c                                  |   23 +-
>  drivers/uio/uio_xgene_qmtm.c                       |  278 ++++++++++++++++++++
>  include/linux/uio_driver.h                         |    1 +
>  8 files changed, 365 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
>  create mode 100644 drivers/uio/uio_xgene_qmtm.c
>
> --
> 1.7.9.5
>
