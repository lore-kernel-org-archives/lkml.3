Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3GXVJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:09:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43003 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GXVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:09:32 -0400
Date: Thu, 25 Jul 2013 00:08:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Won Kang <wkang77@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, wonkang@gctsemi.com
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
Message-ID: <20130724210857.GX5585@mwanda>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
 <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:36:17AM +0900, Won Kang wrote:
> +- Explain reason for multiples of 512 bytes in alloc_tx_struct()

Actually I remembered that I had seen this before in gdm_usb_send()
from drivers/staging/gdm72xx/gdm_usb.c.  Apparently there is a
firmware bug.

        /*
         * In some cases, USB Module of WiMax is blocked when data size is
         * the multiple of 512. So, increment length by one in that case.
         */
	if ((len % 512) == 0)
        	len++;

regards,
dan carpenter
