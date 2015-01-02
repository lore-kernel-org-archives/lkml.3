Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbbABS4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:56:43 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:43647 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbABS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:56:41 -0500
Date: Fri, 2 Jan 2015 13:56:39 -0500
From: Matthew Emerson <emersonmde@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: changes stop ap mode to use reset
 function
Message-ID: <20150102185639.GA12315@gmail.com>
Mail-Followup-To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1419819736-4861-1-git-send-email-emersonmde@gmail.com>
 <wrfjoaqhmb91.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <wrfjoaqhmb91.fsf@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 10:51:38AM -0500, Jes Sorensen wrote:
> Matthew Emerson <emersonmde@gmail.com> writes:
> > Changes stop_ap_mode23a() to use rtw_reset_securitypriv23a. This makes
> > the code cleaner and fixes two checkpatch.pl errors, one line over 80
> > characters, and one spacing issue.
> >
> > Signed-off-by: Matthew Emerson <emersonmde@gmail.com>
> > ---
> >  drivers/staging/rtl8723au/core/rtw_ap.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
> > index e394d12c36b0..510ee212496f 100644
> > --- a/drivers/staging/rtl8723au/core/rtw_ap.c
> > +++ b/drivers/staging/rtl8723au/core/rtw_ap.c
> > @@ -1870,10 +1870,8 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
> >  	pmlmepriv->update_bcn = false;
> >  	pmlmeext->bstart_bss = false;
> >  
> > -	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
> > -	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
> > -	padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;
> > -	padapter->securitypriv.ndisencryptstatus = Ndis802_11WEPDisabled;
> > +	/* reset and init security priv */
> > +	rtw_reset_securitypriv23a(padapter);
> 
> This is broken, rtw_reset_securitypriv23a() takes different actions
> based on the value of adapter->securitypriv.dot11AuthAlgrthm - you leave
> it at it's old value, which does not have the same effect as the above.
> 
> If anything you should remove the memset() and call
> rtw_reset_securitypriv23a() after the two assignments.
> 
> NACK
> 
> Jes

Thank you for you feedback! I had noticed that the two assignments above
(for .ndisauthtype and .ndisencryptstatus) take place in both branches
of the if statement in rtw_reset_securitypriv23a() so I thought removing
them here would be okay. I'll be sure to make the changes you suggested.

Thanks for your time,
Matthew Emerson
