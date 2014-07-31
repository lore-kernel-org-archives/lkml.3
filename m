Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaGaWNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:13:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60578 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750952AbaGaWNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:13:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Arjun Sreedharan <arjun024@gmail.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Subject: Re: [PATCH] Replace faulty is_hex_digit() by isxdigit()
Date: Fri, 01 Aug 2014 00:31:43 +0200
Message-ID: <5145034.POXy6gNNQG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53DA6F69.5050500@infradead.org>
References: <53D9895A.1030902@infradead.org> <1406797489-4296-1-git-send-email-arjun024@gmail.com> <53DA6F69.5050500@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2014 09:31:37 AM Randy Dunlap wrote:
> On 07/31/14 02:04, Arjun Sreedharan wrote:
> > 0 is ascii for NULL. Hex digit matching should be from '0'.
> > Faulty version returns true for #,$,%,& etc.
> > 
> > Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks!

> Thanks.
> 
> > ---
> >  drivers/acpi/acpi_pnp.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
> > index 4ddb0dc..996fa19 100644
> > --- a/drivers/acpi/acpi_pnp.c
> > +++ b/drivers/acpi/acpi_pnp.c
> > @@ -12,6 +12,7 @@
> >  
> >  #include <linux/acpi.h>
> >  #include <linux/module.h>
> > +#include <linux/ctype.h>
> >  
> >  static const struct acpi_device_id acpi_pnp_device_ids[] = {
> >  	/* soc_button_array */
> > @@ -320,11 +321,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
> >  	{""},
> >  };
> >  
> > -static bool is_hex_digit(char c)
> > -{
> > -	return (c >= 0 && c <= '9') || (c >= 'A' && c <= 'F');
> > -}
> > -
> >  static bool matching_id(char *idstr, char *list_id)
> >  {
> >  	int i;
> > @@ -335,7 +331,7 @@ static bool matching_id(char *idstr, char *list_id)
> >  	for (i = 3; i < 7; i++) {
> >  		char c = toupper(idstr[i]);
> >  
> > -		if (!is_hex_digit(c)
> > +		if (!isxdigit(c)
> >  		    || (list_id[i] != 'X' && c != toupper(list_id[i])))
> >  			return false;
> >  	}
> > 
> 
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
