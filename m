Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaLBKN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:13:58 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:33597 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLBKN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:13:57 -0500
Date: Tue, 2 Dec 2014 11:13:46 +0100
From: Thomas Huth <thuth@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: Re: [PATCH v8 03/50] mic_virtio: robust feature array size
 calculation
Message-ID: <20141202111346.785c6f31@oc7435384737.ibm.com>
In-Reply-To: <1417449619-24896-4-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
	<1417449619-24896-4-git-send-email-mst@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120210-0017-0000-0000-0000020D639B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 18:02:59 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> mic reads sizeof(vdev->features) bits from device, but in fact it stores
> bits in local features variable. use sizeof(features) to make code
> robust against future changes extending sizeof(vdev->features).
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/misc/mic/card/mic_virtio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
> index 4f070ad..d5da9ff 100644
> --- a/drivers/misc/mic/card/mic_virtio.c
> +++ b/drivers/misc/mic/card/mic_virtio.c
> @@ -76,8 +76,7 @@ static u32 mic_get_features(struct virtio_device *vdev)
>  	u8 __iomem *in_features = mic_vq_features(desc);
>  	int feature_len = ioread8(&desc->feature_len);
> 
> -	bits = min_t(unsigned, feature_len,
> -		sizeof(vdev->features)) * 8;
> +	bits = min_t(unsigned, feature_len, sizeof(features)) * 8;
>  	for (i = 0; i < bits; i++)
>  		if (ioread8(&in_features[i / 8]) & (BIT(i % 8)))
>  			features |= BIT(i);

Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>

