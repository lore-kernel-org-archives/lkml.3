Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaBMFJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:09:58 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62311 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaBMFJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:09:57 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 13 Feb 2014 14:09:59 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 4/4] zram: document max_comp_streams
Message-ID: <20140213050959.GB5882@bbox>
References: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392233976-26473-6-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392233976-26473-6-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:39:36PM +0300, Sergey Senozhatsky wrote:
> Add max_comp_streams device attribute documentation.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-block-zram |  9 ++++++++-
>  Documentation/blockdev/zram.txt            | 20 +++++++++++++++-----
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
> index 8aa0468..0da9ed6 100644
> --- a/Documentation/ABI/testing/sysfs-block-zram
> +++ b/Documentation/ABI/testing/sysfs-block-zram
> @@ -50,7 +50,6 @@ Description:
>  		The failed_reads file is read-only and specifies the number of
>  		failed reads happened on this device.
>  
> -
>  What:		/sys/block/zram<id>/failed_writes
>  Date:		February 2014
>  Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> @@ -58,6 +57,14 @@ Description:
>  		The failed_writes file is read-only and specifies the number of
>  		failed writes happened on this device.
>  
> +What:		/sys/block/zram<id>/max_comp_streams
> +Date:		February 2014
> +Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> +Description:
> +		The max_comp_streams file is read-write and specifies the
> +		number of backend's zcomp_strm compression streams (number of
> +		concurrent compress operations).
> +
>  What:		/sys/block/zram<id>/notify_free
>  Date:		August 2010
>  Contact:	Nitin Gupta <ngupta@vflare.org>
> diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
> index b31ac5e..c6a55fb 100644
> --- a/Documentation/blockdev/zram.txt
> +++ b/Documentation/blockdev/zram.txt
> @@ -21,7 +21,17 @@ Following shows a typical sequence of steps for using zram.
>  	This creates 4 devices: /dev/zram{0,1,2,3}
>  	(num_devices parameter is optional. Default: 1)
>  
> -2) Set Disksize
> +2) Set max number of compression streams
> +	Compression backend may use up to max_comp_streams compression streams,
> +	thus allowing up to max_comp_streams concurrent compression operations.
> +	Examples:
> +	#set max buffers to 3

Pz, don't use buffers.

> +	echo 3 > /sys/block/zram0/max_comp_streams
> +
> +	#show max buffers

Ditto.

> +	cat /sys/block/zram0/max_comp_streams
> +
> +3) Set Disksize
>          Set disk size by writing the value to sysfs node 'disksize'.
>          The value can be either in bytes or you can use mem suffixes.
>          Examples:
> @@ -38,14 +48,14 @@ There is little point creating a zram of greater than twice the size of memory
>  since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
>  size of the disk when not in use so a huge zram is wasteful.
>  
> -3) Activate:
> +4) Activate:
>  	mkswap /dev/zram0
>  	swapon /dev/zram0
>  
>  	mkfs.ext4 /dev/zram1
>  	mount /dev/zram1 /tmp
>  
> -4) Stats:
> +5) Stats:
>  	Per-device statistics are exported as various nodes under
>  	/sys/block/zram<id>/
>  		disksize
> @@ -60,11 +70,11 @@ size of the disk when not in use so a huge zram is wasteful.
>  		compr_data_size
>  		mem_used_total
>  
> -5) Deactivate:
> +6) Deactivate:
>  	swapoff /dev/zram0
>  	umount /dev/zram1
>  
> -6) Reset:
> +7) Reset:
>  	Write any positive value to 'reset' sysfs node
>  	echo 1 > /sys/block/zram0/reset
>  	echo 1 > /sys/block/zram1/reset
> -- 
> 1.9.0.rc3.256.g4af3ebd
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
