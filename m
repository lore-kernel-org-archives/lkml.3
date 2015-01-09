Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbbAIWrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:47:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbbAIWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:47:08 -0500
Date: Fri, 9 Jan 2015 14:47:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: xiaomin1 <xiaoming.wang@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        Zhang Dongxing <dongxing.zhang@intel.com>
Subject: Re: [PATCH] move file->f_op->open out of mutex (misc_mtx) in
 misc_open
Message-ID: <20150109224707.GA3026@kroah.com>
References: <1420504447-9670-1-git-send-email-xiaoming.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420504447-9670-1-git-send-email-xiaoming.wang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 08:34:07AM +0800, xiaomin1 wrote:
> misc_mtx was used to mutex misc_list.
> But file->f_op->open may be blocked by downloading
> firmware in some devices' open.
> So move file->f_op->open out of mutex (misc_mtx)
> in misc_open to avoid this block.
> It also make code more efficiency.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> ---
>  drivers/char/misc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)


Please fix up your "From:" line to match your signed-off-by line, as I
can't take it the way you sent this.

greg k-h
