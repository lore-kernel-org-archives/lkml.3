Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaGaAKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:10:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:44934 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaGaAKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:10:08 -0400
Message-ID: <53D9895A.1030902@infradead.org>
Date: Wed, 30 Jul 2014 17:10:02 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arjun Sreedharan <arjun024@gmail.com>, rjw@rjwysocki.net
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Subject: Re: [PATCH] Replace faulty is_hex_digit() by isxdigit()
References: <1406750412.12100.65.camel@joe-AO725> <1406765155-22755-1-git-send-email-arjun024@gmail.com>
In-Reply-To: <1406765155-22755-1-git-send-email-arjun024@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/14 17:05, Arjun Sreedharan wrote:
> 0 is ascii for NULL. Hex digit matching should be from '0'.
> Unfixed version returns true for #,$,%,& etc.
> 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  drivers/acpi/acpi_pnp.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> index 4ddb0dc..6d5922d 100644
> --- a/drivers/acpi/acpi_pnp.c
> +++ b/drivers/acpi/acpi_pnp.c

#include <linux/ctype.h>

Thanks.

> @@ -320,11 +320,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
>  	{""},
>  };
>  
> -static bool is_hex_digit(char c)
> -{
> -	return (c >= 0 && c <= '9') || (c >= 'A' && c <= 'F');
> -}
> -
>  static bool matching_id(char *idstr, char *list_id)
>  {
>  	int i;
> @@ -335,7 +330,7 @@ static bool matching_id(char *idstr, char *list_id)
>  	for (i = 3; i < 7; i++) {
>  		char c = toupper(idstr[i]);
>  
> -		if (!is_hex_digit(c)
> +		if (!isxdigit(c)
>  		    || (list_id[i] != 'X' && c != toupper(list_id[i])))
>  			return false;
>  	}
> 


-- 
~Randy
