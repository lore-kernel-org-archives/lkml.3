Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaIET6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:58:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaIET6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:58:54 -0400
Date: Fri, 5 Sep 2014 12:58:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: linux-kernel@vger.kernel.org, lmctlx@gmail.com,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14-stable] usb: gadget: f_fs: drop duplicate
 usb_functionfs_descs_head declaration
Message-ID: <20140905195853.GA26296@kroah.com>
References: <1409943884-13823-1-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409943884-13823-1-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 09:04:44PM +0200, Karol Lewandowski wrote:
> Applicable for 3.14-stable only.
> 
> This commit drops duplicate declaration of struct usb_functionfs_descs_head
> erronousely added in commit 28c5980b54 ("usb: gadget: f_fs: resurect
> usb_functionfs_descs_head structure").
> 
> Fix from 28c5980b54 is applicable only for v3.15-rc1 and newer kernels.
> 
> This fixes error in uapi:
> 
>   /src/linux$ make -C tools usb
> 
>   make: Entering directory '/src/linux/tools'
>     DESCEND  usb
>   make[1]: Entering directory '/src/linux/tools/usb'
>   gcc -Wall -Wextra -g -I../include -o testusb testusb.c -lpthread
>   gcc -Wall -Wextra -g -I../include -o ffs-test ffs-test.c -lpthread
>   In file included from ffs-test.c:41:0:
>   ../../include/uapi/linux/usb/functionfs.h:42:8: error: redefinition of ‘struct usb_functionfs_descs_head’
>    struct usb_functionfs_descs_head {
>           ^
>   ../../include/uapi/linux/usb/functionfs.h:31:8: note: originally defined here
>    struct usb_functionfs_descs_head {
>           ^
> 
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> ---
>  include/uapi/linux/usb/functionfs.h | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
> index 29e9c7a..f279394 100644
> --- a/include/uapi/linux/usb/functionfs.h
> +++ b/include/uapi/linux/usb/functionfs.h
> @@ -27,24 +27,18 @@ struct usb_endpoint_descriptor_no_audio {
>  	__u8  bInterval;
>  } __attribute__((packed));
>  
> -/* Legacy format, deprecated as of 3.14. */
> -struct usb_functionfs_descs_head {
> -	__le32 magic;
> -	__le32 length;
> -	__le32 fs_count;
> -	__le32 hs_count;
> -} __attribute__((packed, deprecated));
>  
>  /*
>   * All numbers must be in little endian order.
>   */
>  
> +/* Legacy format, deprecated as of 3.14. */
>  struct usb_functionfs_descs_head {
>  	__le32 magic;
>  	__le32 length;
>  	__le32 fs_count;
>  	__le32 hs_count;
> -} __attribute__((packed));
> +} __attribute__((packed, deprecated));
>  
>  /*
>   * Descriptors format:
> -- 
> 2.0.1

Ah, well, instead I should just revert
28c5980b5494b8163d6cba5a5007b6ec7e63de66 as it shouldn't have gone to
3.14-stable, right?  I'll do that for the next round of stable releases
after this one.

thanks,

greg k-h
