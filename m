Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaJ0PaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:30:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42960 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJ0PaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:30:14 -0400
Date: Mon, 27 Oct 2014 11:15:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
        zajec5@gmail.com, arend@broadcom.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcma: fix build when CONFIG_OF_ADDRESS is not set
Message-ID: <20141027151509.GA19976@tuxdriver.com>
References: <5436D3CF.2030506@hauke-m.de>
 <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
 <20141025203653.GA10716@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141025203653.GA10716@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I have it queued.  Things have been delayed due to my recent
travels, etc.

On Sat, Oct 25, 2014 at 01:36:53PM -0700, Guenter Roeck wrote:
> On Thu, Oct 09, 2014 at 11:39:41PM +0200, Hauke Mehrtens wrote:
> > Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> > introduces a hard dependency on OF_ADDRESS into the bcma driver.
> > OF_ADDRESS is specifically disabled for the sparc architecture.
> > This results in the following error when building sparc64:allmodconfig.
> > 
> > drivers/bcma/main.c: In function 'bcma_of_find_child_device':
> > drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'
> > 
> > Fixes: 2101e533f41a ("bcma: register bcma as device tree driver")
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> The upstream kernel still does not include this patch, and the sparc64 build
> is still broken.
> 
> Is this patch on its way upstream ?
> 
> Guenter
> 
> > ---
> >  drivers/bcma/main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> > index d1656c2..1000955 100644
> > --- a/drivers/bcma/main.c
> > +++ b/drivers/bcma/main.c
> > @@ -132,7 +132,7 @@ static bool bcma_is_core_needed_early(u16 core_id)
> >  	return false;
> >  }
> >  
> > -#ifdef CONFIG_OF
> > +#if defined(CONFIG_OF) && defined(CONFIG_OF_ADDRESS)
> >  static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
> >  						     struct bcma_device *core)
> >  {
> > -- 
> > 1.9.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
