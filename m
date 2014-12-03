Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaLCGBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:01:30 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64363 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLCGB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:01:29 -0500
Date: Wed, 3 Dec 2014 11:31:21 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Hedman <paul@mybboard.net>
Cc: paul@mybb.com, greg@kroah.com, marek.belisko@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: fix spaces around operators in
 ft1000_debug.c
Message-ID: <20141203060121.GB17730@sudip-PC>
References: <1417570240-3139-1-git-send-email-paul@mybb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417570240-3139-1-git-send-email-paul@mybb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 07:30:40PM -0600, Paul Hedman wrote:
> Fixes spacing issues around operators, e.g. i=0 to i = 0, as
> found by the checkpatch.pl tool.

no Signed-off-by ???

please run your patch through checkpatch before sending.

thanks
sudip

> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 28 ++++++++++++------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
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
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
