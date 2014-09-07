Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaIGLnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 07:43:47 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:46333 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaIGLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 07:43:46 -0400
MIME-Version: 1.0
In-Reply-To: <1409963352-2193-1-git-send-email-kys@microsoft.com>
References: <1409963352-2193-1-git-send-email-kys@microsoft.com>
Date: Sun, 7 Sep 2014 19:43:45 +0800
Message-ID: <CAFeW=paZ23VF6QTapGb6jR2-A_bkUYRTaOL9y_TULtASpj+2fw@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Drivers: hv: vmbus: Enable interrupt driven flow control
From: Amos Kong <kongjianjun@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, open list <linux-kernel@vger.kernel.org>,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 8:29 AM, K. Y. Srinivasan <kys@microsoft.com> wrote:
>
> In win8 we have a feature that allows for interrupt driven flow management
> for host/guest communication. For instance, if the host were blocked because
> there was no space available in the ringbuffer, the host could request that the
> guest send an interrupt when space becomes available in the ringbuffer (when
> the guest drains the ringbuffer).
>
> While this feature was implemented in the guest a while ago, we had not
> advertised that the guest supported this feature. This patch advertises
> the support to the host.
>
> For pre-win8 hosts, this has no effect since the size of the ringbuffer
> control structure has not changed and all changes have been backward
> compatible - unused/reserved space has been used to implement this
> feature.
>
> In this version of the patch I have cleaned up the commit log based on
> feedback from Greg KH.
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
>         ring_info->ring_buffer->read_index =
>                 ring_info->ring_buffer->write_index = 0;
>
> +       /*
> +        * Set the feature bit for enabling flow control.
> +        */
> +       ring_info->ring_buffer->feature_bits.value = 1;
> +

This feature is enabled, do we need to reset  pending_send_sz and
reserved1[12], reserved1[4028] here?

>         ring_info->ring_size = buflen;
>         ring_info->ring_datasize = buflen - sizeof(struct hv_ring_buffer);
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
