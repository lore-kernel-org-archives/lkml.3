Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaHFR0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:26:47 -0400
Received: from lvnode1.ve.v10networks.ca ([209.141.36.111]:35346 "EHLO
	lvnode1.ve.v10networks.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbaHFR0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:26:45 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 13:26:45 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] Drivers: net-next: hyperv: Adjust the size of sendbuf region to support ws2008r2
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 6 Aug 2014 10:18:46 -0700
Message-ID: <A70AC0C1B7E7FD478A6BF19705461AA011098B@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <1407348660-6844-1-git-send-email-kys@microsoft.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] Drivers: net-next: hyperv: Adjust the size of sendbuf region to support ws2008r2
Thread-Index: Ac+xmc8BhmtfhvrBSkKfu8mVTEKq9AAAHYwA
References: <1407348660-6844-1-git-send-email-kys@microsoft.com>
From: "Jeff Leung" <jleung@v10networks.ca>
To: "K. Y. Srinivasan" <kys@microsoft.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@linuxdriverproject.org>, <olaf@aepfle.de>, <apw@canonical.com>,
        <jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> WS2008R2 is a supported platform and it turns out that the maximum
sendbuf
> size that ws2008R2 can support is only 15MB. Make the necessary
> adjustment.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/hyperv/hyperv_net.h
b/drivers/net/hyperv/hyperv_net.h
> index 40ba1ef..459b823 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -584,7 +584,7 @@ struct nvsp_message {
> 
>  #define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024*16)	/* 16MB
> */
>  #define NETVSC_RECEIVE_BUFFER_SIZE_LEGACY	(1024*1024*15)  /* 15MB
*/
> -#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024 *
16)   /* 16MB */
> +#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024 *
15)   /* 15MB */

Would it be possible to use separate ifdefs depending on the version of
the Hyper-V host so we can maintain the 16MB buffer for hosts that
support it and leave it at 15MB for hosts that don't support that large
of a buffer? 

>  #define NETVSC_INVALID_INDEX			-1
> 
> 
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

