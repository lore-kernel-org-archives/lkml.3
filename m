Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3DLVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 17:51:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48764 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3DLVv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 17:51:28 -0400
Date: Fri, 12 Apr 2013 14:51:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] base/core.c: improve comment of the function
 device_find_child()
Message-ID: <20130412215125.GA16042@kroah.com>
References: <1365767972-23727-1-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365767972-23727-1-git-send-email-federico.vaga@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 01:59:32PM +0200, Federico Vaga wrote:
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> ---
>  drivers/base/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 016312437..eb0c6ea 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1372,6 +1372,10 @@ int device_for_each_child(struct device *parent, void *data,
>   * if it does.  If the callback returns non-zero and a reference to the
>   * current device can be obtained, this function will return to the caller
>   * and not iterate over any more devices.
> + *
> + * NOTE: internally, the function does get_device() on the retrieved child.
> + * It is duty of the caller performing a put_device() on the retrieved
> + * child device when the caller finishes to work on it.
>   */

Why not just use the same wording that class_find_device() has, which is
simpler and easier to understand (IMHO)?

thanks,

greg k-h
