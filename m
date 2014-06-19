Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbaFSUUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:20:41 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54334 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbaFSUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <1403209102-10633-1-git-send-email-xerofoify@gmail.com>
References: <1403209102-10633-1-git-send-email-xerofoify@gmail.com>
Date: Thu, 19 Jun 2014 16:20:39 -0400
Message-ID: <CAPDOMVhBHa3QqFY+5T+noCxKkffN6Mo0PrN1_1ZRV22RNXUKXg@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192 Check for Null return from dev_skb_alloc
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lisa@xenapiadmin.com, Valentina Manea <valentina.manea.m@gmail.com>,
        ben@decadent.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,
So Sorry about wasting your time with bad patchs.
I feel bad about that. I hope this patch is O.K.
now. :(
Nicholas Krause

On Thu, Jun 19, 2014 at 4:18 PM, Nicholas Krause <xerofoify@gmail.com> wrote:
> Checks for Null return from dev_skb_alloc if it returns Null,
> fw_download returns false. Otherwise it returns true.Also
> removed rt_status due to returning true of false directly.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 1a95d1f..affa89a 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -36,7 +36,6 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>                              u32 buffer_len)
>  {
>         struct r8192_priv *priv = rtllib_priv(dev);
> -       bool                rt_status = true;
>         u16                 frag_threshold;
>         u16                 frag_length, frag_offset = 0;
>         int                 i;
> @@ -59,7 +58,9 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>                         bLastIniPkt = 1;
>
>                 }
> -
> +               skb  = dev_alloc_skb(frag_length + 4);
> +               if (!skb)
> +                       return false;
>                 skb  = dev_alloc_skb(frag_length + 4);
>                 memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>                 tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
> @@ -99,7 +100,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>
>         write_nic_byte(dev, TPPoll, TPPoll_CQ);
>
> -       return rt_status;
> +       return false;
>  }
>
>  static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
> --
> 1.9.1
>
