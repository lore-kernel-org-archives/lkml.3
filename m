Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaCUOXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:23:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaCUOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:23:05 -0400
Date: Fri, 21 Mar 2014 07:24:29 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Matt Sickler <Matt.Sickler@daktronics.com>
Cc: "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: UIO read(2)/write(2) overrides
Message-ID: <20140321142429.GA25833@kroah.com>
References: <8FAD17D1809CB042A0963E8337B9FE3DD7D823@MB-EXC-04.daktronics.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FAD17D1809CB042A0963E8337B9FE3DD7D823@MB-EXC-04.daktronics.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 02:20:11PM +0000, Matt Sickler wrote:
> Tiny patch to let uio-based drivers override the read(2), write(2), and poll(2) syscalls.
> The rationale is that some uio-based drivers might want the mmap(2) functionality
> of UIO, but have no need for the IRQ semantics of read(2) and write(2).

Can you submit a driver that uses these new interfaces as well?  I don't
want to add something that isn't used in the kernel.

> 
> Signed-Off-by: Matt Sickler <Matt.Sickler@daktronics.com>
> ---
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index a673e5b..da1bfc8 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -505,6 +505,9 @@ static unsigned int uio_poll(struct file *filep, poll_table *wait)
>     struct uio_listener *listener = filep->private_data;
>     struct uio_device *idev = listener->dev;
> 
> +   if (idev->info->poll)
> +       return idev->info->poll(filep, wait);
> +

Your email client ate all the tabs and created a patch that can't be
applied :(

