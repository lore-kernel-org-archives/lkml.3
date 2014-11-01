Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaKAFFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:05:45 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44826 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaKAFFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:05:44 -0400
Date: Sat, 1 Nov 2014 10:35:35 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chen Weixiang <weixiangchen@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] staging: ft1000: spaces required around that '=',
 '<' and '=='
Message-ID: <20141101050535.GC3642@sudip-PC>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:47:22AM +0800, Chen Weixiang wrote:
> Remove following code style errors from ft1000/ft1000-usb/ft1000_debug.c
> and ft1000/ft1000-pcmcia/ft1000_hw.c:
> ERROR: spaces required around that '=' (ctx:VxV)
> ERROR: spaces required around that '<' (ctx:VxV)
> ERROR: spaces required around that '==' (ctx:VxV)
> 

many whitespace errors in the patch.
checkpatch gives total: 8 errors, 23 warnings, 125 lines checked

thanks
sudip

> Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |  6 ++---
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 28 ++++++++++++------------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> index 44575c7..fc28dee 100644
> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> @@ -812,11 +812,11 @@ static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size,
>  
>      /* Make sure SLOWQ doorbell is clear */
>      tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
> -    i=0;
> +    i = 0;
>      while (tempword & FT1000_DB_DPRAM_TX) {
>          mdelay(10);
>          i++;
> -        if (i==10) {
> +        if (i == 10) {
>              spin_unlock_irqrestore(&info->dpram_lock, flags);
>              return;
>          }
> @@ -1221,7 +1221,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
>  				ppseudo_hdr->portsrc = 0;
>  				/* Calculate new checksum */
>                  ppseudo_hdr->checksum = *pmsg++;
> -                for (i=1; i<7; i++) {
> +                for (i = 1; i < 7; i++) {
>                      ppseudo_hdr->checksum ^= *pmsg++;
>                  }
>  				pmsg = (u16 *) & tempbuffer[16];
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> index 0f347ab..02bfb3e 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
> @@ -193,7 +193,7 @@ int ft1000_create_dev(struct ft1000_usb *dev)
>  
>      /* initialize application information */
>      dev->appcnt = 0;
> -    for (i=0; i<MAX_NUM_APP; i++) {
> +    for (i = 0; i < MAX_NUM_APP; i++) {
>          dev->app_info[i].nTxMsg = 0;
>          dev->app_info[i].nRxMsg = 0;
>          dev->app_info[i].nTxMsgReject = 0;
> @@ -260,7 +260,7 @@ void ft1000_destroy_dev(struct net_device *netdev)
>  					   dev->DeviceName);
>  
>          /* Make sure we free any memory reserve for slow Queue */
> -        for (i=0; i<MAX_NUM_APP; i++) {
> +        for (i = 0; i < MAX_NUM_APP; i++) {
>              while (list_empty(&dev->app_info[i].app_sqlist) == 0) {
>                  pdpram_blk = list_entry(dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
>                  list_del(&pdpram_blk->list);
> @@ -318,7 +318,7 @@ static int ft1000_open(struct inode *inode, struct file *file)
>      }
>  
>      /* Search for available application info block */
> -    for (i=0; i<MAX_NUM_APP; i++) {
> +    for (i = 0; i < MAX_NUM_APP; i++) {
>          if ((dev->app_info[i].fileobject == NULL)) {
>              break;
>          }
> @@ -369,7 +369,7 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
>      }
>  
>      /* Search for matching file object */
> -    for (i=0; i<MAX_NUM_APP; i++) {
> +    for (i = 0; i < MAX_NUM_APP; i++) {
>          if (dev->app_info[i].fileobject == &file->f_owner) {
>              /* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", dev->app_info[i].app_id); */
>              break;
> @@ -411,7 +411,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>      void __user *argp = (void __user *)argument;
>  	struct ft1000_info *info;
>      struct ft1000_usb *ft1000dev;
> -    int result=0;
> +    int result = 0;
>      int cmd;
>      int i;
>      u16 tempword;
> @@ -426,8 +426,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>                            0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x01,0x00,0x01,0x7f,0x00,
>                            0x00,0x01,0x00,0x00};
>  
> -    unsigned short ledStat=0;
> -    unsigned short conStat=0;
> +    unsigned short ledStat = 0;
> +    unsigned short conStat = 0;
>  
>      /* DEBUG("ft1000_ioctl called\n"); */
>  
> @@ -454,7 +454,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>              }
>              if (tempword == DSPBCMSGID) {
>                  /* Search for matching file object */
> -                for (i=0; i<MAX_NUM_APP; i++) {
> +                for (i = 0; i < MAX_NUM_APP; i++) {
>                      if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
>                          ft1000dev->app_info[i].DspBCMsgFlag = 1;
>                          DEBUG("FT1000:ft1000_ioctl:Registered for broadcast messages\n");
> @@ -581,12 +581,12 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>                      result = -EFAULT;
>                  } else {
>                      /* Check if this message came from a registered application */
> -                    for (i=0; i<MAX_NUM_APP; i++) {
> +                    for (i = 0; i < MAX_NUM_APP; i++) {
>                          if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
>                              break;
>                          }
>                      }
> -                    if (i==MAX_NUM_APP) {
> +                    if (i == MAX_NUM_APP) {
>                          DEBUG("FT1000:No matching application fileobject\n");
>                          result = -EINVAL;
>  			kfree(dpram_data);
> @@ -646,7 +646,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>                              /* Calculate new checksum */
>                              ppseudo_hdr->checksum = *pmsg++;
>                              /* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
> -                            for (i=1; i<7; i++) {
> +                            for (i = 1; i < 7; i++) {
>                                  ppseudo_hdr->checksum ^= *pmsg++;
>                                  /* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
>                              }
> @@ -682,7 +682,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
>              }
>  
>              /* Search for matching file object */
> -            for (i=0; i<MAX_NUM_APP; i++) {
> +            for (i = 0; i < MAX_NUM_APP; i++) {
>                  if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
>                      /*DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
>                      break;
> @@ -766,14 +766,14 @@ static int ft1000_release(struct inode *inode, struct file *file)
>      }
>  
>      /* Search for matching file object */
> -    for (i=0; i<MAX_NUM_APP; i++) {
> +    for (i = 0; i < MAX_NUM_APP; i++) {
>          if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
>              /* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
>              break;
>          }
>      }
>  
> -    if (i==MAX_NUM_APP)
> +    if (i == MAX_NUM_APP)
>  	    return 0;
>  
>      while (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
