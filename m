Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaAFURb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:17:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAFUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:17:28 -0500
Date: Mon, 6 Jan 2014 12:17:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: rjw@rjwysocki.net, shuahkhan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] drivers/bus: Add Legacy PM OPS usage check and
 warning to bus_register()
Message-ID: <20140106201755.GA7339@kroah.com>
References: <cover.1389034060.git.shuah.kh@samsung.com>
 <1b1d24cd7140784f96b9d1fee9cace9da04a88f5.1389034060.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b1d24cd7140784f96b9d1fee9cace9da04a88f5.1389034060.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:03:21PM -0700, Shuah Khan wrote:
> Add Legacy PM OPS usage checks to bus_register() function. If Legacy PM OPS
> usage is found, print warning message to indicate that the driver code needs
> updating to use Dev PM OPS interfaces. This will help serve as a way to track
> drivers that still use Legacy PM OPS and fix them.
> 
> The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
> resume(struct device *) bus level interfaces.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/base/bus.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 73f6c29..e8753a7 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -916,6 +916,9 @@ int bus_register(struct bus_type *bus)
>  		goto bus_groups_fail;
>  
>  	pr_debug("bus: '%s': registered\n", bus->name);
> +	if (bus->suspend || bus->resume)
> +		pr_warn("bus '%s' needs updating - use pm pointer.\n",
> +			bus->name);

Why can't we just sweep the tree for all of these now, fix them up, and
then delete these fields and be done with it?

Same for the other ones, putting warnings in the kernel log files
doesn't work at all for getting people to fix up their code (see
examples of scsi log messages being there for _years_ about obsolete
driver interfaces being used.)

thanks,

greg k-h
