Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaKZJup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:50:45 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:49407 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaKZJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:50:43 -0500
Date: Wed, 26 Nov 2014 10:50:33 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 18/42] virtio_blk: make serial attribute static
Message-ID: <20141126105033.6167484e.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-19-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-19-git-send-email-mst@redhat.com>
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
x-cbid: 14112609-0013-0000-0000-000001FE2282
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:42:42 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> It's never declared so no need to make it extern.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/block/virtio_blk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index f601f16..055f3df 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -332,7 +332,8 @@ static ssize_t virtblk_serial_show(struct device *dev,
> 
>  	return err;
>  }
> -DEVICE_ATTR(serial, S_IRUGO, virtblk_serial_show, NULL);
> +
> +static DEVICE_ATTR(serial, S_IRUGO, virtblk_serial_show, NULL);
> 
>  static void virtblk_config_changed_work(struct work_struct *work)
>  {

The virtio-blk attributes might benefit from a conversion to attribute
groups (which support masking and so on), but that's a different
cleanup. So, fwiw:

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

