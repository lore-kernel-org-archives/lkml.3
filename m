Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaLZKRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 05:17:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaLZKRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 05:17:13 -0500
Message-ID: <549D359E.7080401@redhat.com>
Date: Fri, 26 Dec 2014 18:17:02 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] virtio-net: using single MSIX irq for each TX/RX
 queue pair
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com> <1419562425-20614-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1419562425-20614-4-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/26/2014 10:53 AM, Jason Wang wrote:
> This patch try to reduce the number of MSIX irqs required for
> virtio-net by sharing a MSIX irq for each TX/RX queue pair through
> channels. If transport support channel, about half of the MSIX irqs
> were reduced.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>

Note: an issue with this patch is it may trigger tx irq handler if at
least one more used. We could solve this by checking the used idx and
bypass the tx irq if host does not signal us. (Or just does the old tx
skbs reclaiming before the checking.)

