Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3HLW6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:58:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HLW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:58:49 -0400
Date: Mon, 12 Aug 2013 15:58:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        AsiasHeasias@redhat.com, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH v2 1/7] Intel MIC Host Driver for X100 family.
Message-ID: <20130812225848.GA30952@kroah.com>
References: <cover.1375927849.git.sudeep.dutt@intel.com>
 <a5214cbe041674f0b5dcd7eb9b581b4d7f923947.1375927849.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5214cbe041674f0b5dcd7eb9b581b4d7f923947.1375927849.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 08:04:07PM -0700, Sudeep Dutt wrote:
> diff --git a/drivers/misc/mic/host/mic_common.h b/drivers/misc/mic/host/mic_common.h
> new file mode 100644
> index 0000000..55b0337
> --- /dev/null
> +++ b/drivers/misc/mic/host/mic_common.h
> @@ -0,0 +1,30 @@
> +/*
> + * Intel MIC Platform Software Stack (MPSS)
> + *
> + * Copyright(c) 2013 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + *
> + * The full GNU General Public License is included in this distribution in
> + * the file called "COPYING".
> + *
> + * Intel MIC Host driver.
> + *
> + */
> +#ifndef _MIC_HOST_COMMON_H_
> +#define _MIC_HOST_COMMON_H_
> +
> +#include <linux/cdev.h>
> +
> +#include "../common/mic_device.h"
> +#include "mic_device.h"
> +#include "mic_x100.h"
> +
> +#endif

Don't create .h files that just wrap other .h files up.  It makes it
hard to unwind stuff and determine exactly what .c files need what .h
files.  Just include the needed .h files properly in the .c code, and
all should be fine.

thanks,

greg k-h
