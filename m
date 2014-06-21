Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbaFUKEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:04:53 -0400
Received: from 200.180.216.87.static.jazztel.es ([87.216.180.200]:56012 "HELO
	mail.sysvalve.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754947AbaFUKEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:04:51 -0400
Date: Sat, 21 Jun 2014 12:04:44 +0200
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8172u: Make ieee80211_crypto_init static
Message-ID: <20140621100444.GA31059@bart.evergreen.loc>
References: <1402594851-16941-1-git-send-email-agimenez@sysvalve.es>
 <20140620001426.GA1351@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140620001426.GA1351@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:14:26PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Jun 12, 2014 at 07:40:49PM +0200, L. Alberto Giménez wrote:
> > Fix sparse warning.
> > 
> > Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> > ---
> >  drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
> > index 5533221..3be690d 100644
> > --- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
> > +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
> > @@ -200,7 +200,7 @@ static struct ieee80211_crypto_ops ieee80211_crypt_null = {
> >  	.owner			= THIS_MODULE,
> >  };
> >  
> > -int __init ieee80211_crypto_init(void)
> > +static int __init ieee80211_crypto_init(void)
> >  {
> >  	int ret = -ENOMEM;
> 
> You obviously did not compile this change :(
> 
> greg k-h

Hi Greg,

I'm very sorry for that, I swear I compiled it, but clearly I'm missing something
here.

My patch compiles with a warning, but tag v3.15 (tag where my branch is based) does
not issue this warning:

drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c:203:19: warning:
‘ieee80211_crypto_init’ defined but not used [-Wunused-function]
 static int __init ieee80211_crypto_init(void)
                   ^

I thought that __init functions could be static, is there any problem with that? Care
to shed some light here?

Thank you very much
-- 
L. Alberto Giménez
GnuPG key ID 0xDD4E27AB
