Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaCZMI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:08:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaCZMI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:08:27 -0400
Date: Wed, 26 Mar 2014 05:10:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jimmy Li <coder.liss@gmail.com>
Cc: Teodora Baluta <teobaluta@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/vt6655/iwctl.c fix a sparse warning
Message-ID: <20140326121011.GA23018@kroah.com>
References: <20140326074243.GA15228@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326074243.GA15228@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 12:42:43AM -0700, Jimmy Li wrote:
> fix a sparse warning.
> drivers/staging/vt6655/iwctl.c:1846:35: warning: cast from restricted
> gfp_t
> drivers/staging/vt6655/iwctl.c:1846:35: warning: incorrect type in
> argument 2 (different base types)
> drivers/staging/vt6655/iwctl.c:1846:35:    expected restricted gfp_t
> [usertype] flags
> drivers/staging/vt6655/iwctl.c:1846:35:    got int [signed] <noident>

In the future, please don't line-wrap error/warning messages like this.

> 
> Signed-off-by: Jimmy Li <coder.liss@gmail.com>
> ---
>  drivers/staging/vt6655/iwctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
> index ac3fc16..5e25535 100644
> --- a/drivers/staging/vt6655/iwctl.c
> +++ b/drivers/staging/vt6655/iwctl.c
> @@ -1843,7 +1843,7 @@ int iwctl_siwencodeext(struct net_device *dev,
>  	PRINT_K("SIOCSIWENCODEEXT...... \n");
>  
>  	blen = sizeof(*param);
> -	buf = kmalloc((int)blen, (int)GFP_KERNEL);
> +	buf = kmalloc((int)blen, GFP_KERNEL);
>  	if (buf == NULL)
>  		return -ENOMEM;
>  	memset(buf, 0, blen);
> -- 
> 1.7.10.4

Thanks, I'll queue this up after 3.15-rc1 is out, as my tree is
currently closed.

greg k-h
