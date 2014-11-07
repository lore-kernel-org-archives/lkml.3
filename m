Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaKGWmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:42:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63036 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752682AbaKGWmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:42:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@infradead.org>
Cc: Giedrius Statkevicius <giedriuswork@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux ACPI Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] platform: x86: remove redundant variable in hp-wireless.c
Date: Sat, 08 Nov 2014 00:03:23 +0100
Message-ID: <9503707.R8535QTB05@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141107182822.GA62564@vmdeb7>
References: <1415144839-2035-1-git-send-email-giedriuswork@gmail.com> <20141107182822.GA62564@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 07, 2014 10:28:23 AM Darren Hart wrote:
> On Wed, Nov 05, 2014 at 01:47:19AM +0200, Giedrius Statkevicius wrote:
> > Remove a variable because it only holds the results of a function call
> > and then gets returned so instead just return the result of a function
> > call.
> > 
> > Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
> > ---
> >  drivers/platform/x86/hp-wireless.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
> > index 415348f..670c62b 100644
> > --- a/drivers/platform/x86/hp-wireless.c
> > +++ b/drivers/platform/x86/hp-wireless.c
> > @@ -82,10 +82,7 @@ static void hpwl_notify(struct acpi_device *acpi_dev, u32 event)
> >  
> >  static int hpwl_add(struct acpi_device *device)
> >  {
> > -	int err;
> > -
> > -	err = hp_wireless_input_setup();
> > -	return err;
> > +	return hp_wireless_input_setup();
> 
> Since acpi_device_probe() does not print a warning if add() fails, it might be
> preferable to print the message here, rather than ignoring it completely.
> 
> Rafael?

Sounds reasonable.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
