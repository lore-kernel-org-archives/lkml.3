Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaLAJ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:56:47 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:52310 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaLAJ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:56:45 -0500
Date: Mon, 1 Dec 2014 10:56:33 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        David Drysdale <drysdale@google.com>,
        stephen hemminger <stephen@networkplumber.org>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        Andy Grover <agrover@redhat.com>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v7 08/46] virtio: memory access APIs
Message-ID: <20141201105633.63ddff73.cornelia.huck@de.ibm.com>
In-Reply-To: <1417359787-10138-9-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-9-git-send-email-mst@redhat.com>
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
x-cbid: 14120109-0025-0000-0000-000002AA158B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 17:09:50 +0200
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
>  include/uapi/linux/virtio_types.h | 46 ++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild         |  1 +
>  5 files changed, 161 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/virtio_byteorder.h
>  create mode 100644 include/uapi/linux/virtio_types.h

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

