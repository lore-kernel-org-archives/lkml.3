Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbaG0XDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:03:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:56264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaG0XDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:03:51 -0400
Message-ID: <53D58550.6040205@infradead.org>
Date: Sun, 27 Jul 2014 16:03:44 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Pavel Machek <pavel@ucw.cz>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Stefan Weil <sw@weilnetz.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: laptops: freefall.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
References: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/14 07:40, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  Documentation/laptops/freefall.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/laptops/freefall.c b/Documentation/laptops/freefall.c
> index aab2ff0..113d004 100644
> --- a/Documentation/laptops/freefall.c
> +++ b/Documentation/laptops/freefall.c
> @@ -33,8 +33,10 @@ static int set_unload_heads_path(char *device)
>  
>  	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
>  		return -EINVAL;
> -	strncpy(devname, device + 5, sizeof(devname) - 1);
> -	strncpy(device_path, device, sizeof(device_path) - 1);

Maybe I am overlooking something here, but what was wrong with
the - 1 (2 times) above?  and then just add the 2 lines below that set the
last byte to '\0'?

> +	strncpy(devname, device + 5, sizeof(devname));
> +	devname[sizeof(devname) - 1] = '\0';
> +	strncpy(device_path, device, sizeof(device_path));
> +	device_path[sizeof(device_path) - 1] = '\0';
>  
>  	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
>  				"/sys/block/%s/device/unload_heads", devname);
> 


-- 
~Randy
