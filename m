Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaC1D3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 23:29:13 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33074 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbaC1D3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 23:29:11 -0400
Date: Thu, 27 Mar 2014 20:28:44 -0700
From: Jimmy Li <coder.liss@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teodora Baluta <teobaluta@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Archana kumari <archanakumari959@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/vt6655/iwctl.c fix a sparse warning
Message-ID: <20140328032844.GC2263@gmail.com>
References: <20140326074243.GA15228@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326074243.GA15228@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 

You are right, I found that variable buf also don't make sense here,
maybe this could be more clear.

    param = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
    if (param == NULL)
        return -ENOMEM;

removing two unnecessary variable, buf and blen.

In this situation, I should send a new patch v2 for it base on the
previous path? or send a new patch include all changes?
