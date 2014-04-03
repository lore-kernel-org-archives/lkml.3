Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaDCTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:16:27 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52501 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaDCTQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:16:23 -0400
Date: Thu, 3 Apr 2014 15:16:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Dave Reisner <d@falconindy.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, thomas@archlinux.org,
        P@draigbrady.com, alexandre.f.demers@gmail.com
Subject: Re: Initramfs FSID altered in 3.14
Message-ID: <20140403191617.GB2472@mtj.dyndns.org>
References: <20140403175744.GE585@rampage>
 <533DA4DE.40408@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <533DA4DE.40408@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 03, 2014 at 08:13:50PM +0200, Thomas Bächler wrote:
> Most of these bugs were not caused by rootfs' FSID being different from
> 1, but rather because there was a file system with FSID 0.
> 
> Only util-linux/switch_root assumed that rootfs always had exactly FSID
> 1 - which is IMO a wrong assumption.
> 
> However, tt seems that people have been assuming that st_dev > 0 for a
> while. If we want to revert this in the kernel, this patch (untested)
> should be sufficient:
> 
> diff --git a/fs/super.c b/fs/super.c
> index 80d5cf2..d9fddde 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -802,7 +802,7 @@ void emergency_remount(void)
>  static DEFINE_IDA(unnamed_dev_ida);
>  static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
> -static int unnamed_dev_start = 0; /* don't bother trying below it */
> +static int unnamed_dev_start = 1; /* don't bother trying below it */
>  int get_anon_bdev(dev_t *p)
>  {

Alexandre, this is the one line change that should fix it.  Can you
please test it?

Thomas, can you please write proper patch description with reference
to the following thread and stable # 3.14 tag?

 http://lkml.kernel.org/g/CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com

Thanks.

-- 
tejun
