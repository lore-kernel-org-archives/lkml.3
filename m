Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaG2ASG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:18:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:33494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaG2ASD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:18:03 -0400
Message-ID: <53D6E832.7020306@infradead.org>
Date: Mon, 28 Jul 2014 17:17:54 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Stefan Weil <sw@weilnetz.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCHv3] Documentation: laptops: freefall.c: simplify to avoid
 null-termination problems
References: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <53D58550.6040205@infradead.org> <20140728102040.GA16495@amd.pavel.ucw.cz> <20140728111351.GB17250@amd.pavel.ucw.cz>
In-Reply-To: <20140728111351.GB17250@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/14 04:13, Pavel Machek wrote:
> 
> Copying to local variable is actually not neccessary, if all we need
> to do is snprintf(). This also removes problem where devname could be
> missing zero termination.
> 
> Reported-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Applied.  Thanks.

> 
> diff --git a/Documentation/laptops/freefall.c b/Documentation/laptops/freefall.c
> index aab2ff0..5e44b20 100644
> --- a/Documentation/laptops/freefall.c
> +++ b/Documentation/laptops/freefall.c
> @@ -29,15 +29,12 @@ static const char app_name[] = "FREE FALL";
>  
>  static int set_unload_heads_path(char *device)
>  {
> -	char devname[64];
> -
>  	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
>  		return -EINVAL;
> -	strncpy(devname, device + 5, sizeof(devname) - 1);
>  	strncpy(device_path, device, sizeof(device_path) - 1);
>  
>  	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
> -				"/sys/block/%s/device/unload_heads", devname);
> +				"/sys/block/%s/device/unload_heads", device+5);
>  	return 0;
>  }
>  
> 
> 
> 


-- 
~Randy
