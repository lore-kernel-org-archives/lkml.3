Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaESQxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:53:47 -0400
Received: from mout.gmx.net ([212.227.17.20]:53370 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbaESQxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:53:45 -0400
Message-ID: <1400518422.4698.8.camel@schoellingm.dzne.de>
Subject: Re: [PATCH 1/3] net: vxge: Use time_is_before_jiffies() for time
 comparison
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Mon, 19 May 2014 18:53:42 +0200
In-Reply-To: <1400518056-12089-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400518056-12089-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:ZKQBpNAgztKb6BIWYCFM5+161Dnarp24/+zR11wck/tqsweYueN
 UIStLHllyn4oDH+w92lx9oi4g1S8fEFpDS7ehE02rDi8EkYMYIPBnhX5FIrj+ZHCjdiC1rd
 FpqT5vVt2tJZ8QjtrofxbdRM5jiRoTXg1YdzWf479OL3W3m2OMq9s6blFmfNuQNTOi7kEfU
 v4o+MrW4SsHabSUHKxgDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, contrary to the subject of this mail, this is a single file
patch.
Patches 2-3 do not exist.

On Mo, 2014-05-19 at 18:47 +0200, Manuel Schölling wrote:
> To be future-proof and for better readability the time comparisons are modified
> to use time_is_before_jiffies() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> ---
>  drivers/net/ethernet/neterion/vxge/vxge-main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
> index d107bcb..79f42db 100644
> --- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
> +++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
> @@ -2122,7 +2122,7 @@ static int vxge_open_vpaths(struct vxgedev *vdev)
>  static void adaptive_coalesce_tx_interrupts(struct vxge_fifo *fifo)
>  {
>  	fifo->interrupt_count++;
> -	if (jiffies > fifo->jiffies + HZ / 100) {
> +	if (time_is_before_jiffies(fifo->jiffies + HZ / 100)) {
>  		struct __vxge_hw_fifo *hw_fifo = fifo->handle;
>  
>  		fifo->jiffies = jiffies;
> @@ -2150,7 +2150,7 @@ static void adaptive_coalesce_tx_interrupts(struct vxge_fifo *fifo)
>  static void adaptive_coalesce_rx_interrupts(struct vxge_ring *ring)
>  {
>  	ring->interrupt_count++;
> -	if (jiffies > ring->jiffies + HZ / 100) {
> +	if (time_is_before_jiffies(ring->jiffies + HZ / 100)) {
>  		struct __vxge_hw_ring *hw_ring = ring->handle;
>  
>  		ring->jiffies = jiffies;


