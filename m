Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaIAJfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:35:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20171 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaIAJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:35:29 -0400
Date: Mon, 1 Sep 2014 12:35:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish_audio.c: sparse warning of incorrect
 type
Message-ID: <20140901093514.GE5122@mwanda>
References: <1409501782-20775-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409501782-20775-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 09:46:22PM +0530, Sudip Mukherjee wrote:
> @@ -133,9 +134,15 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
>  						AUDIO_READ_BUFFER_AVAILABLE);
>  
>  		/* copy data to user space */
> -		if (copy_to_user(buf, data->read_buffer, length))
> +		buffer = kzalloc(length, GFP_KERNEL);
> +		if (buffer == NULL)
> +			return -ENOMEM;
> +		memcpy_fromio(buffer, data->read_buffer, length);
> +		if (copy_to_user((void __user *)buf, buffer, length)) {
                                 ^^^^^^^^^^^^^^^
This cast shouldn't be needed.

regards,
dan carpenter

