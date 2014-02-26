Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaBZLcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:32:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26785 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaBZLcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:32:05 -0500
Date: Wed, 26 Feb 2014 14:31:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, bergwolf@gmail.com,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: make functions as static
Message-ID: <20140226113138.GP26722@mwanda>
References: <3395735.omIA0Togio@daeseok-laptop.cloud.net>
 <20140226092050.GO26722@mwanda>
 <CAHb8M2DiKuiD4A4-HuNRvkAgZ24uon1ekzAq9OiEE+36qHXcDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2DiKuiD4A4-HuNRvkAgZ24uon1ekzAq9OiEE+36qHXcDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 08:11:40PM +0900, DaeSeok Youn wrote:
> Actually , I saw some code like this file which is seperate line
> between return value and function name.
> So I didn't make one line of them.
> 
> Ok, I will make another patch after merge this one.

No, you are misunderstanding what I am saying.  Those type of function
declarations are allowed in the kernel so the original code is fine.
What I am saying is this patch is doing two thing but it should be doing
only one thing.

>  @@ -53,8 +53,8 @@ lnd_t the_o2iblnd = {
>  
>  kib_data_t	      kiblnd_data;
>  
> -__u32
> -kiblnd_cksum (void *ptr, int nob)
> +static __u32
> +kiblnd_cksum(void *ptr, int nob)
>  {
>  	char  *c  = ptr;
>  	__u32  sum = 0;

Changing the white space here is OK because it is a minor related
white space change.

> @@ -368,7 +368,7 @@ kiblnd_create_peer(lnet_ni_t *ni, kib_peer_t **peerp, lnet_nid_t nid)
>  }
>  
>  void
> -kiblnd_destroy_peer (kib_peer_t *peer)
> +kiblnd_destroy_peer(kib_peer_t *peer)
> {

This is a random unrelated white space change, so do it in a separate
patch.

regards,
dan carpenter

