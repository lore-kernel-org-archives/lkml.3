Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3IZPWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:22:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3IZPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:22:46 -0400
Date: Thu, 26 Sep 2013 08:22:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 5/5] mei: revamp read and write length checks
Message-ID: <20130926152245.GA26343@kroah.com>
References: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
 <1378080664-7274-6-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378080664-7274-6-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 03:11:04AM +0300, Tomas Winkler wrote:
> 1. Return zero on zero length read and writes
> 2. For a too large write return -EFBIG as defined in man write(2)
> EFBIG  An attempt was made to write a file that
>         exceeds the implementation-defined maximum
>         file size or the process's file size limit,
>         or to  write  at  a  position  past  the  maximum
>         allowed offset.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/main.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
> index 5ff810b..7404584 100644
> --- a/drivers/misc/mei/main.c
> +++ b/drivers/misc/mei/main.c
> @@ -203,12 +203,18 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
>  
>  	dev = cl->dev;
>  
> +
>  	mutex_lock(&dev->device_lock);

Not a big deal, but why the extra line?

greg k-h
