Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaLBSjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:39:42 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:38707 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaLBSjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:39:40 -0500
Date: Tue, 2 Dec 2014 19:39:30 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 1/2] virtio_balloon: convert to virtio 1.0
 endian-ness
Message-ID: <20141202193930.2b8750f7.cornelia.huck@de.ibm.com>
In-Reply-To: <1417520617-2135-1-git-send-email-mst@redhat.com>
References: <1417520617-2135-1-git-send-email-mst@redhat.com>
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
x-cbid: 14120218-0025-0000-0000-000002B1BF43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 13:44:06 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> balloon device is not part of virtio 1.0 spec.  Still, it's easy enough
> to make it handle endian-ness exactly as other virtio 1.0 devices: what
> we gain from this, is that there's no need to special-case it in virtio
> core.

Well, the balloon is weird in a number of ways, including its always
little-endian config space.

But I'm not quite sure the spec covers this?

> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_balloon.h | 5 +++--
>  drivers/virtio/virtio_balloon.c     | 4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 

>  struct virtio_balloon_stat {
> -	__u16 tag;
> -	__u64 val;
> +	__virtio16 tag;
> +	__virtio64 val;
>  } __attribute__((packed));

Would the respective fields in the spec need updating? While it is
actually talking about legacy requirements, the fields are not
specified as __virtio{16,64}.

Also, is changing the stat fields enough? I've not looked into balloon
operation, but does the payload need some endianess conversion as well?

