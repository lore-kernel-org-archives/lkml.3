Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaKYRmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:42:51 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38542 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaKYRmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:42:49 -0500
Date: Tue, 25 Nov 2014 18:42:38 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        stephen hemminger <stephen@networkplumber.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 05/42] virtio: memory access APIs
Message-ID: <20141125184238.0a4436f8.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-6-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-6-git-send-email-mst@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112517-0017-0000-0000-000001F99814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:41:42 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio 1.0 makes all memory structures LE, so
> we need APIs to conditionally do a byteswap on BE
> architectures.
> 
> To make it easier to check code statically,
> add virtio specific types for multi-byte integers
> in memory.
> 
> Add low level wrappers that do a byteswap conditionally, these will be
> useful e.g. for vhost.  Add high level wrappers that
> query device endian-ness and act accordingly.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_byteorder.h  | 59 +++++++++++++++++++++++++++++++++++++++
>  include/linux/virtio_config.h     | 32 +++++++++++++++++++++
>  include/uapi/linux/virtio_ring.h  | 45 ++++++++++++++---------------
>  include/uapi/linux/virtio_types.h | 48 +++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild         |  1 +
>  5 files changed, 163 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/virtio_byteorder.h
>  create mode 100644 include/uapi/linux/virtio_types.h
> 
> diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> new file mode 100644
> index 0000000..824ed0b
> --- /dev/null
> +++ b/include/linux/virtio_byteorder.h
> @@ -0,0 +1,59 @@
> +#ifndef _LINUX_VIRTIO_BYTEORDER_H
> +#define _LINUX_VIRTIO_BYTEORDER_H
> +#include <linux/types.h>
> +#include <uapi/linux/virtio_types.h>
> +
> +/*
> + * Memory accessors for handling virtio in modern little endian and in

"Low-level memory accessors"?

> + * compatibility native endian format.
> + */
(...)
> diff --git a/include/uapi/linux/virtio_types.h b/include/uapi/linux/virtio_types.h
> new file mode 100644
> index 0000000..b90385f
> --- /dev/null
> +++ b/include/uapi/linux/virtio_types.h
> @@ -0,0 +1,48 @@
> +#ifndef _UAPI_LINUX_VIRTIO_TYPES_H
> +#define _UAPI_LINUX_VIRTIO_TYPES_H
> +/* An interface for efficient virtio implementation, currently for use by KVM
> + * and lguest, but hopefully others soon.  

You probably copied this from the existing virtio header, didn't you?

What about simply:

"Type definitions for virtio implementations."

(and then the remaining text)

> Do NOT change this since it will
> + * break existing servers and clients.
> + *
> + * This header is BSD licensed so anyone can use the definitions to implement
> + * compatible drivers/servers.
(...)

