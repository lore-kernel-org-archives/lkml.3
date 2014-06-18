Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaFRWpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:45:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaFRWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:45:48 -0400
Date: Wed, 18 Jun 2014 15:49:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: devel@driverdev.osuosl.org, lisa@xenapiadmin.com, ben@decadent.org.uk,
        valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2]staging:rtl8192e:check return value of dev_skb_alloc
Message-ID: <20140618224947.GA2472@kroah.com>
References: <1403130180-5634-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403130180-5634-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:23:00PM -0400, Nicholas Krause wrote:
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 11e915e..fde17ff 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -62,12 +62,15 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
> +		if (!skb) 
> +			return !rt_status;
>  		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>  		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>  		tcb_desc->queue_index = TXCMD_QUEUE;
>  		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
>  		tcb_desc->bLastIniPkt = bLastIniPkt;
> -		
>  
>  		seg_ptr = skb->data;
>  		for (i = 0; i < frag_length; i += 4) {

Again, always use checkpatch.pl before sending out patches...

