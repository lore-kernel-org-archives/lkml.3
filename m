Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaDCUad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:30:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbaDCUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:30:29 -0400
Date: Thu, 3 Apr 2014 13:32:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: tj@kernel.org, d@falconindy.com, linux-kernel@vger.kernel.org,
        P@draigbrady.com, alexandre.f.demers@gmail.com,
        "3.14" <stable@vger.kernel.org>
Subject: Re: [PATCHv2] fs: Don't return 0 from get_anon_bdev
Message-ID: <20140403203252.GA8855@kroah.com>
References: <20140403195154.GD2472@mtj.dyndns.org>
 <1396554937-11952-1-git-send-email-thomas@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396554937-11952-1-git-send-email-thomas@archlinux.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:55:37PM +0200, Thomas Bächler wrote:
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
>  fs/super.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 80d5cf2..7624267 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -802,7 +802,10 @@ void emergency_remount(void)
>  
>  static DEFINE_IDA(unnamed_dev_ida);
>  static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
> -static int unnamed_dev_start = 0; /* don't bother trying below it */
> +/* Many userspace utilities consider an FSID of 0 invalid.
> + * Always return at least 1 from get_anon_bdev.
> + */
> +static int unnamed_dev_start = 1;
>  
>  int get_anon_bdev(dev_t *p)
>  {

Very nice, I'll go queue this one up instead of the other patch from
Tejun.

greg k-h
