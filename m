Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaDCTwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:52:06 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:63551 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaDCTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:52:00 -0400
Date: Thu, 3 Apr 2014 15:51:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: d@falconindy.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        P@draigbrady.com, alexandre.f.demers@gmail.com,
        "3.14" <stable@vger.kernel.org>
Subject: Re: [PATCH] fs: Don't return 0 from get_anon_bdev
Message-ID: <20140403195154.GD2472@mtj.dyndns.org>
References: <20140403191617.GB2472@mtj.dyndns.org>
 <1396554595-11796-1-git-send-email-thomas@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396554595-11796-1-git-send-email-thomas@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:49:55PM +0200, Thomas Bächler wrote:
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

Provided Alexandre confirms the fix.

 Acked-by: Tejun Heo <tj@kernel.org>

> ---
>  fs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 80d5cf2..d9fddde 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -802,7 +802,7 @@ void emergency_remount(void)
>  
>  static DEFINE_IDA(unnamed_dev_ida);
>  static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
> -static int unnamed_dev_start = 0; /* don't bother trying below it */
> +static int unnamed_dev_start = 1; /* don't bother trying below it */

Maybe a comment saying that userland considers fsid 0 to be invalid
would be nice?

Thanks.

-- 
tejun
