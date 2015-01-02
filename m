Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbbABPvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:51:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbbABPvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:51:52 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Matthew Emerson <emersonmde@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: changes stop ap mode to use reset function
References: <1419819736-4861-1-git-send-email-emersonmde@gmail.com>
Date: Fri, 02 Jan 2015 10:51:38 -0500
In-Reply-To: <1419819736-4861-1-git-send-email-emersonmde@gmail.com> (Matthew
	Emerson's message of "Sun, 28 Dec 2014 21:22:16 -0500")
Message-ID: <wrfjoaqhmb91.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Emerson <emersonmde@gmail.com> writes:
> Changes stop_ap_mode23a() to use rtw_reset_securitypriv23a. This makes
> the code cleaner and fixes two checkpatch.pl errors, one line over 80
> characters, and one spacing issue.
>
> Signed-off-by: Matthew Emerson <emersonmde@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_ap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
> index e394d12c36b0..510ee212496f 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ap.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ap.c
> @@ -1870,10 +1870,8 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
>  	pmlmepriv->update_bcn = false;
>  	pmlmeext->bstart_bss = false;
>  
> -	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
> -	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
> -	padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;
> -	padapter->securitypriv.ndisencryptstatus = Ndis802_11WEPDisabled;
> +	/* reset and init security priv */
> +	rtw_reset_securitypriv23a(padapter);

This is broken, rtw_reset_securitypriv23a() takes different actions
based on the value of adapter->securitypriv.dot11AuthAlgrthm - you leave
it at it's old value, which does not have the same effect as the above.

If anything you should remove the memset() and call
rtw_reset_securitypriv23a() after the two assignments.

NACK

Jes
