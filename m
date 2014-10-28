Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaJ1OLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:11:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaJ1OLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:11:52 -0400
Date: Tue, 28 Oct 2014 22:10:38 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 03/11] drivers: char: add AXD Audio Processing IP driver
Message-ID: <20141028141038.GA18384@kroah.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <1414495589-8579-4-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414495589-8579-4-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:26:21AM +0000, Qais Yousef wrote:
> AXD is Audio Processing IP by Imagination Technologies that can
> perform decoding, encoding, equalisation, resampling, mixing,
> synchronisation and audio playback.

Isn't that a codec?  Why is this a "char" driver and not one that fits
into our existing audio subsystem?

> this patch adds defs and initialisation files

Spell check :)

> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <alsa-devel@alsa-project.org>
> ---
>  drivers/char/axd/axd_api.h    |  641 +++++++++++++++++++++++++
>  drivers/char/axd/axd_module.c | 1064 +++++++++++++++++++++++++++++++++++++++++
>  drivers/char/axd/axd_module.h |   99 ++++
>  include/linux/axd.h           |   32 ++
>  4 files changed, 1836 insertions(+)
>  create mode 100644 drivers/char/axd/axd_api.h
>  create mode 100644 drivers/char/axd/axd_module.c
>  create mode 100644 drivers/char/axd/axd_module.h
>  create mode 100644 include/linux/axd.h
> 
> diff --git a/drivers/char/axd/axd_api.h b/drivers/char/axd/axd_api.h
> new file mode 100644
> index 000000000000..0d732f173f55
> --- /dev/null
> +++ b/drivers/char/axd/axd_api.h
> @@ -0,0 +1,641 @@
> +/*
> + *  Copyright (C) 2011-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.

Do you really mean "any later version"?


> + *
> + *  Main API to the AXD for access from the host.
> + */
> +#ifndef AXD_API_H_
> +#define AXD_API_H_
> +
> +#include <linux/types.h>
> +
> +
> +#define THREAD_COUNT 4
> +#define AXD_MAX_PIPES 3
> +
> +
> +#define AXD_DESCRIPTOR_READY_BIT	0x80000000
> +#define AXD_DESCRIPTOR_INUSE_BIT	0x40000000
> +#define AXD_DESCRIPTOR_EOS_BIT		0x20000000
> +#define AXD_DESCRIPTOR_SIZE_MASK	0x0000FFFF
> +
> +struct axd_buffer_desc {
> +	uint32_t status_size;
> +	uint32_t data_ptr;
> +	uint32_t pts_high;
> +	uint32_t pts_low;

Please always use standard Linux kernel types, "u32" in this case.

thanks,

greg k-h
