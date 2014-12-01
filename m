Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaLAMVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:21:03 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:42454 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaLAMVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:21:02 -0500
Date: Mon, 1 Dec 2014 13:20:51 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 30/46] vhost/net: force len for TX to host endian
Message-ID: <20141201132051.4ab028d9.cornelia.huck@de.ibm.com>
In-Reply-To: <1417359787-10138-31-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-31-git-send-email-mst@redhat.com>
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
x-cbid: 14120112-0041-0000-0000-00000250ED59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 17:11:44 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> vhost/net keeps a copy of some used ring but (ab)uses length
> field for internal house-keeping. This works because
> for tx used length is always 0.
> Suppress sparse errors: we use native endian-ness internally but never
> expose it to guest.

I admit that I find this patch description hard to read :)


"vhost/net keeps a copy of the used ring in host memory but (ab)uses
the length field for internal house-keeping. This works because the
length in the used ring for tx is always 0. In order to suppress sparse
errors, we need to force native endianness."

?

> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 8dae2f7..dce5c58 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -48,15 +48,15 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
>   * status internally; used for zerocopy tx only.
>   */
>  /* Lower device DMA failed */
> -#define VHOST_DMA_FAILED_LEN	3
> +#define VHOST_DMA_FAILED_LEN	((__force __virtio32)3)
>  /* Lower device DMA done */
> -#define VHOST_DMA_DONE_LEN	2
> +#define VHOST_DMA_DONE_LEN	((__force __virtio32)2)
>  /* Lower device DMA in progress */
> -#define VHOST_DMA_IN_PROGRESS	1
> +#define VHOST_DMA_IN_PROGRESS	((__force __virtio32)1)
>  /* Buffer unused */
> -#define VHOST_DMA_CLEAR_LEN	0
> +#define VHOST_DMA_CLEAR_LEN	((__force __virtio32)0)
> 
> -#define VHOST_DMA_IS_DONE(len) ((len) >= VHOST_DMA_DONE_LEN)
> +#define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >= (__force u32)VHOST_DMA_DONE_LEN)
> 
>  enum {
>  	VHOST_NET_FEATURES = VHOST_FEATURES |

