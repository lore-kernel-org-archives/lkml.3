Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaJFORj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:17:39 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:54262 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaJFORh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:17:37 -0400
Date: Mon, 6 Oct 2014 16:17:28 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 16/16] virtio_net: fix use after free on allocation
 failure
Message-ID: <20141006161728.5a329eea.cornelia.huck@de.ibm.com>
In-Reply-To: <1412525038-15871-17-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-17-git-send-email-mst@redhat.com>
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
x-cbid: 14100614-8372-0000-0000-0000016DE39F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 19:07:38 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> In the extremely unlikely event that driver initialization fails after
> RX buffers are added, virtio net frees RX buffers while VQs are
> still active, potentially causing device to use a freed buffer.
> 
> To fix, reset device first - same as we do on device removal.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

