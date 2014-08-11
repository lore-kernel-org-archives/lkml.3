Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaHKVso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 17:48:44 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41542 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaHKVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 17:48:43 -0400
Date: Mon, 11 Aug 2014 14:48:24 -0700
From: Jerry Snitselaar <dev@snitselaar.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        ben@decadent.org.uk, lisa@xenapiadmin.com, valentina.manea.m@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: Check against NULL in fw_download_code
Message-ID: <20140811214824.GA19333@cantor.redhat.com>
Reply-To: Jerry Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Nicholas Krause <xerofoify@gmail.com>,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	ben@decadent.org.uk, lisa@xenapiadmin.com,
	valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org
References: <1407786342-26282-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407786342-26282-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Aug 11 14, Nicholas Krause wrote:
> I am fixing the bug entry , https://bugzilla.kernel.org/show_bug.cgi?id=60461.
> This entry states that we are not checking the skb allocated in fw_download_code
> and after checking I fixed it to check for the NULL value before using the allocate
> skb.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 1a95d1f..817e50e 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -61,6 +61,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  		}
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
> +		if (skb == NULL)
> +			return !rt_status;
>  		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>  		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>  		tcb_desc->queue_index = TXCMD_QUEUE;
> -- 
> 1.9.1


Look at fw_download_code() in drivers/staging/rtl8192u/r819xU_firmware.c
