Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbbATKlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:41:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbbATKlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:41:13 -0500
Date: Tue, 20 Jan 2015 16:10:40 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 04/16] virtio/console: verify device has config space
Message-ID: <20150120104040.GJ31174@grmbl.mre>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421256142-11512-5-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421256142-11512-5-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 14 Jan 2015 [19:27:35], Michael S. Tsirkin wrote:
> Some devices might not implement config space access
> (e.g. remoteproc used not to - before 3.9).
> virtio/console needs config space access so make it
> fail gracefully if not there.

Do we know any such devices?  Wondering what prompted this patch.  If
it's just theoretical, I'd rather let it be like this, and pull this
in when there's a device that doesn't have config space.

Also, just the console functionality (i.e. F_MULTIPORT is unset) is
available w/o config space access.  In fact, getting this patch in
would mean remoteproc wouldn't even run in its pre-config days...

> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index de03df9..26afb56 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -1986,6 +1986,12 @@ static int virtcons_probe(struct virtio_device *vdev)
>  	bool multiport;
>  	bool early = early_put_chars != NULL;
>  
> +	if (!vdev->config->get) {
> +		dev_err(&vdev->dev, "%s failure: config access disabled\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +


		Amit
