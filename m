Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaIETLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:11:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIETLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:11:49 -0400
Date: Fri, 5 Sep 2014 12:11:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
 control
Message-ID: <20140905191148.GA24879@kroah.com>
References: <1409941402-486-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409941402-486-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:23:22AM -0700, K. Y. Srinivasan wrote:
> This is a win8 feature that has been implemented. Turn on the feature bit
> to enable the feature.

What does those two sentances even mean?

> With this feature turned on,

What is "this"?

> when the host is waiting
> for space to become available on the ringbuffer (host to guest), the guest
> will interrupt the host when space becomes available (as part of draining
> the ring buffer).
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/ring_buffer.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 15db66b..6361d12 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -361,6 +361,11 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
>  	ring_info->ring_buffer->read_index =
>  		ring_info->ring_buffer->write_index = 0;
>  
> +	/*
> +	 * Set the feature bit for enabling flow control.
> +	 */
> +	ring_info->ring_buffer->feature_bits.value = 1;

What happens if you are running on an old system that doesn't support
this new "feature"?

thanks,

greg k-h
