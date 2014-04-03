Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaDCXlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:41:22 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62628 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaDCXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:41:19 -0400
Message-ID: <533DF19B.4090601@gmail.com>
Date: Thu, 03 Apr 2014 19:41:15 -0400
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Reply-To: alexandre.f.demers@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>, tj@kernel.org
CC: d@falconindy.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        P@draigbrady.com, "3.14" <stable@vger.kernel.org>
Subject: Re: [PATCH] fs: Don't return 0 from get_anon_bdev
References: <20140403191617.GB2472@mtj.dyndns.org> <1396554595-11796-1-git-send-email-thomas@archlinux.org>
In-Reply-To: <1396554595-11796-1-git-send-email-thomas@archlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It works over here, tested on 3.14-rc8 which was previously failing. You 
have my

Tested-by: Alexandre Demers

Alexandre Demers

On 04/03/2014 03:49 PM, Thomas Bächler wrote:
> Commit 9e30cc9595303b27b48 removed an internal mount. This
> has the side-effect that rootfs now has FSID 0. Many
> userspace utilities assume that st_dev in struct stat
> is never 0, so this change breaks a number of tools in
> early userspace.
>
> Since we don't know how many userspace programs are affected,
> make sure that FSID is at least 1.
>
> References: http://article.gmane.org/gmane.linux.kernel/1666905
> References: http://permalink.gmane.org/gmane.linux.utilities.util-linux-ng/8557
> Cc: 3.14 <stable@vger.kernel.org>
> Signed-off-by: Thomas Bächler <thomas@archlinux.org>
> ---
>   fs/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/super.c b/fs/super.c
> index 80d5cf2..d9fddde 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -802,7 +802,7 @@ void emergency_remount(void)
>   
>   static DEFINE_IDA(unnamed_dev_ida);
>   static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
> -static int unnamed_dev_start = 0; /* don't bother trying below it */
> +static int unnamed_dev_start = 1; /* don't bother trying below it */
>   
>   int get_anon_bdev(dev_t *p)
>   {

