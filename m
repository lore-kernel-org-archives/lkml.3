Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaD1JZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:25:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20108 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaD1JZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:25:40 -0400
Date: Mon, 28 Apr 2014 12:25:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: Use USB subsystem functions to check
 endpoint type
Message-ID: <20140428092523.GS26890@mwanda>
References: <1398530635-3813-1-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398530635-3813-1-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 10:13:55PM +0530, navin patidar wrote:
> Use inline functions provided by USB subsystem to check endpoint type,
> instead of macros implemented by driver to do the same.
> 
> Unnecessary debugging messages are also removed.
> 

I like both these changes but they would have been so much easier to
review if you deleted the debugging messagese in [patch 1/2] and then
changed the endpoint functions in [patch 2/2].

> @@ -183,60 +143,36 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
>  	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
>  
>  	for (i = 0; i < pdvobjpriv->nr_endpoint; i++) {
> +

Don't put a blank line here, btw.

> +		int ep_num;
>  		phost_endp = phost_iface->endpoint + i;

Anyway, please resend because it needs to be broken into two patches.

regards,
dan carpenter

