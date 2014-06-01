Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaFAW2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 18:28:33 -0400
Received: from mout.gmx.net ([212.227.15.19]:59250 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbaFAW23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 18:28:29 -0400
Date: Mon, 2 Jun 2014 00:28:22 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Cort <linuxgeek@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] staging: rtl8712: rtl871x_ioctl_linux.c: Cleaning up
 memory leak
Message-ID: <20140602002822.39fe7c9e@spike>
In-Reply-To: <1401622243-13364-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401622243-13364-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Ktf+Hnk0g+GohUM9bvQwih9Zq3pUl0q3vthMGhM+OYYjgoAs/kA
 o4lQ0mwrxeQbG4DC8mf8vSmv8y20DKUTLSil3RfdYc5Dmgk1vcEqFITyV961shFmJcBldEq
 K9AYVFYu9lMxeGsRtBoBNU//0XPaV4mCgcIFbhRI6YtAOqjjfUTj/XSU/SFBINIIZ5Xc3Sj
 aEXBUjiinJozNtu3Y6ETQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Jun 2014 13:30:43 +0200, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> There is a risk for memory leak in when something unexpected happens
> and the function returns.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 23d539d..27e0243 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -1822,6 +1822,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
>  		alg_name = "CCMP";
>  		break;
>  	default:
> +		kfree(param);
>  		return -EINVAL;
>  	}
>  	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);

Hi Rickard,

This one doesn't apply either. Commit 55d4f6cc (staging: rtl8712: fix potential
leak in r871x_wx_set_enc_ext()) moved the input verification to the beginning
of the function so that the direct return no longer hurt. This change was also
already in flight at the time of Your first version of the patch in May.

Please check that Your patches are based on linux-next.

Best Regards,
Christian
