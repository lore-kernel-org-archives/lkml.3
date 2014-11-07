Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaKGSTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:19:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaKGSTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:19:05 -0500
Date: Fri, 7 Nov 2014 10:19:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matej =?utf-8?Q?Mu=C5=BEila?= <mmuzila@redhat.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        kys@microsoft.com, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v2 1/3] tools: hv: fcopy_daemon: Check buffer limits
Message-ID: <20141107181904.GA11874@kroah.com>
References: <544658CE.8050704@redhat.com>
 <544671E2.3000905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <544671E2.3000905@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:46:58PM +0200, Matej Mužila wrote:
> From: Matej Mužila <mmuzila@redhat.com>
> 
> Check if cpmsg->size is in limits of DATA_FRAGMENT
> 
> Signed-off-by: Matej Mužila <mmuzila@redhat.com>
> ---
> 
> If corrupted data are read from /dev/vmbus/hv_fcopy, pwrite can
> read from memory outside of the buffer (defined at line 138).
> Added check. 
> 
> Changes made since v1:
> 	* max value of cmesg->size is now derived from structure
> 	  definition in sources/include/uapi/linux/hyperv.h
> 	* Fixed comments
> 
> 
> diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
> index 6f27e2f..1fc2dc2 100644
> --- a/tools/hv/hv_fcopy_daemon.c
> +++ b/tools/hv/hv_fcopy_daemon.c
> @@ -104,6 +104,10 @@ static int hv_copy_data(struct hv_do_fcopy *cpmsg)
>  {
>  	ssize_t bytes_written;
>  
> +	/* Check if the cpmsg->size is in limits of DATA_FRAGMENT */
> +	if (cpmsg->size > sizeof(cpmsg->data)) 
> +		return HV_E_FAIL;
> +
>  	bytes_written = pwrite(target_fd, cpmsg->data, cpmsg->size,
>  				cpmsg->offset);
> 

ALWAYS run your patches through checkpatch before sending them, so you
don't get grumpy emails from maintainers telling you to do the same
thing...

Please fix this up and resend the whole series.

thanks,

greg k-h
