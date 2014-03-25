Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaCYAgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:36:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaCYAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:36:43 -0400
Date: Mon, 24 Mar 2014 17:38:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: john@jjdev.com, ced@ryick.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] staging/usbip: fix store_attach() sscanf return value
 check
Message-ID: <20140325003854.GB10953@kroah.com>
References: <1395702729-3281-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395702729-3281-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 05:12:09PM -0600, Shuah Khan wrote:
> Fix commit - 88fa1ebfa21b5deaaad2dc88ecd9f6af91796cf7

What do you mean by this line?

> This commit added return value check for sscanf() that parses the
> input buffer for four input items. However, the return value check
> is incorrect, as it checks for one input item instead of four which
> is what it is expecting in the input buffer. As a result, sscanf()
> will always fail even when the input buffer is correct.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/staging/usbip/vhci_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
> index e098032..1ff24e9 100644
> --- a/drivers/staging/usbip/vhci_sysfs.c
> +++ b/drivers/staging/usbip/vhci_sysfs.c
> @@ -183,7 +183,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
>  	 * @devid: unique device identifier in a remote host
>  	 * @speed: usb device speed in a remote host
>  	 */
> -	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 1)
> +	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 4)
>  		return -EINVAL;
>  
>  	usbip_dbg_vhci_sysfs("rhport(%u) sockfd(%u) devid(%u) speed(%u)\n",
> -- 
> 1.7.10.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
