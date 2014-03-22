Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaCVAq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:46:29 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:65506 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaCVAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:46:26 -0400
MIME-Version: 1.0
In-Reply-To: <1391714737-6835-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20140205230634.GA25598@kroah.com> <1391714737-6835-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Sat, 22 Mar 2014 01:45:44 +0100
X-Google-Sender-Auth: a4biH9ibuRCeO__GO95w--a7seA
Message-ID: <CAH+eYFAnc+k+3kSH4_YDRG-zX_ioBwZ_jGdpyvUWFqf_=6kYGA@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: Fix obex in g_nokia.ko causing kernel panic
To: balbi@ti.com, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae94edbd3f9f8df04f5275443
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae94edbd3f9f8df04f5275443
Content-Type: text/plain; charset=ISO-8859-1

2014-02-06 20:25 GMT+01:00 Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>:
> From: Felipe Balbi <balbi@ti.com>

This patch, which is present in 3.14-rc4 as 30a70b026 ("usb: musb: fix
obex in g_nokia.ko causing kernel panic"), breaks USB gadget support
on my Pandaboard.  Bisecting points to this commit, reverting it makes
USB gadget support work again.  The problem is that this patch deletes
the call which turns on the PHY.

Config is attached.

> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index 2a408cd..8aa59a2 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -659,7 +659,6 @@ static int omap2430_runtime_suspend(struct device *dev)
>                                 OTG_INTERFSEL);
>
>                 omap2430_low_level_exit(musb);
> -               phy_power_off(musb->phy);
>         }
>
>         return 0;
> @@ -674,7 +673,6 @@ static int omap2430_runtime_resume(struct device *dev)
>                 omap2430_low_level_init(musb);
>                 musb_writel(musb->mregs, OTG_INTERFSEL,
>                                 musb->context.otg_interfsel);
> -               phy_power_on(musb->phy);
>         }
>
>         return 0;

--14dae94edbd3f9f8df04f5275443
Content-Type: application/x-gzip; name="panda-usb-config.gz"
Content-Disposition: attachment; filename="panda-usb-config.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ht269jjp0

H4sICADcLFMAA3BhbmRhLXVzYi1jb25maWcAfVjJktw2Er3PV3TIV0eIZFV1Vx/qAAIgCTexCABr
0QXhReFRjKR2jHrG9t87QdaSINh9qAXvYUfmywSoVo1ogzu5vTB09/e/6AQY7cQxyA8DH/gNVTp0
H2/FTrRdsNwFLyS37kbUjgVjNeXOBUKpvzHiafqTI2ODG9xr6GZogutE43fl/bXr/ikwvg9CCW/Z
rT4/Gm7RQK4nNVqO1Y3ohULj6glDq3sCpOZoGVKzoc+B0GhLOcyQsIwa1CI8tVgg97BvQqt8DGfp
mQuk74H+4W62A7Vr7z5/v/v2/HL3/dPLdaXEeuHHZmxPFOVoPGJpF+TQexH292gnJDHxGLkPtNf0
yc0oORxhwHpoZz1FslrAVgvYGp2MpiO0SSEiV6vjMcWYJQ8YI1YG3w2y5jwFubXEk7Auy8eqQH1I
g4zXBmoGt6suAJXkxn6stfbBahiAH/2u+KvImdo5TMSBiTFcMc4C83U6JZhPG9FAtTQEWSaVDCyR
79799/n5Zff+t0//f//166+/fPlP8Ud1F7E/f/78cvfr87fvz18+7V5e/tbVj2W5qYri3dVS+ZEj
X6mFaqQPUjjswXJ+aIqjWRhCn3B5UAJt9LGBFQyO26Q1jHvKABi2hc1HByKSgYSZTI4Sl6JGmXk5
sI7mYNz/HLXEGuwWcdTQW4194kaa/f2Cs0ATkACPl0mJ2n1FhUBfgYLpiQe/ljeu9vh/6KgYwBuX
sNAhh0BwTZ1ZJEYJSOCayqpYHee914aUBUJp026LqixviCT0FSRYGozAAoUIxhsC55hWGPieKxiX
96C+YFO+2717//2Xz9/e//v55Y8v//v9arKgWF6aBmnLBQHFGxQyDSZJ6pqjCGlqKoeNA34Up16j
s5OeJYWLq42i6FKqjkqXQlqbWSXaiAwAQ/O8jxqRMIooliNzjRyHUTyvfAYDaL5oTuFgBfYoXGOh
x6FG07yEhx6Wk6OWyEUwOPGRQ5hdbddX8eTKaQvB3fXVZlMgQ5Om2G6CqOgNu1TuhVvNGOoWZufQ
+mONc1jqBzXDXXQ14k4KSZtEjcGFoT9BcZh+ctvtppyXg8RO5CR9LHG4kQ4AjMB0qHEHpOp+Cw4X
THdKm6XI4Or4STQwYlGexkE2OKJFhvSw/M39qprBqnrAwSxi3Ditqu12m8JPtCofUdVe1JAMEXc7
hQsSqy+gjgm9AM8CyKGHTcHFsjoiqYHyNi1TbSGTMSLHkvHkQTSCHzNguVq6BKHM4MNP+gRWgENQ
RPk+ASFY1ZpYFloD3eawJN4KNIsr4Q/9ulgV8+69HmjnqOUcGS0CIQNzD9v1/bxdGqfPfU1DBHOw
9eC9Vji09bwl9BSMP7mFIAZRWpA+bKsNznxuYFRKp3Gii0nIioZRHVfVEg06N+Y3y40lUTAtnYgr
5l1H4LCF/bBMM+5BwV/nrSMZoZtb4M04kMZFMN+C7gCqp5hGnYBqBQoTTmwmGi8uTPK7xi5shKLe
9qCgqsVDjM4zs7VYipctHAdHLDOxA9Ivow8QXd1gTI+l5yK58mFzM1rfcSsJErozEFq9Dw0RdjqU
ZT5mfLBKQjEvxlQ863fM6pfhTQ7HTH5T5fiBeNox3aYdLMAXB8kZ2cBlk/SSuBTzxt1vqvJhAX0s
i6Tn+2Id3QRvi+XtAHambdb3jRn7KqrV69zD8VUumdmMS+aHuLmRNOjO0QgrD9HdOMMZWlPHGyU/
p2guITxcf+teeJ9ejKOFB+ZQ9LhCUZEXasJHJD1PScq1PRMOnPYUuKIwF1hIY9Zl8QZvWFm5otzk
Va5pX2B78RbdMbnAG6J4HxgOSTXchHrRdpBkUzZ6mcYPCRGkPYmLHPOMlMm1qIFsCjy/aWAdmews
kHCz9CRe2FHHukWa4SA9ZiifmhUgnByhN43PK8KGyhyE9LLWDhJiC1ksSn8jNwv2ERrTkCEJwhEG
PUgBRvYggiInpkv9KCB8L1NudPSsxQWd/lws/o0qpOYXF36j2iqePNOW3OrENCLJomYbMOVgCnaf
csjeDiHLM2MNiQ8uAgcmU8CBNZKWz5rFr45ZugCPzmP6YTYSO9BVMvvgOb5Sj+sFGD+/wPZvxow1
Xe24XyCm2Ra0hLXzxHXClnYHMyG+pbm3+BnJ4a54U2ZJk0IYlCMNj69Sg8SZC9jimK+ktdPAf0FC
h4aMB9hzhpBYmjwbaa2nSxCz+7hnj9UKqy9iUlm+EOm04F6bWRAEV87wXTdeftNmkIFRbGNTOYtK
l9OvkppVsu0ArCbgmlqeoXAk3tuF5BL4ddLHhwHkChXjw9Me30cd0y5psW+IT4DZO8BPTePSeU4I
nLwk9pRXnCY7x+MzG5jL+GKqjU8fVacq/Uc9hyzcnbED16JJZ09BsXFZzfhY3q8Cof0MQw88Nj4g
qqRVD6YHoc6AMIT16iFlhNNwYX0MOAUcBXt8aJ9nmEI1aFmStILGFDNJqmkHxg5hJjE9GZO9FDRW
7+PLNn2aUoKrnUxDweccQRbvIXSwwp/w3p2M1xCgIK2GqAu/uMszS5SLF22rll6zqQV/pJCh4E4h
GS0LJpoUE34IaTW0q3CjBWBVIZVptMIrj8Ww/WubIWW8v/0DldhBrycZAAA=
--14dae94edbd3f9f8df04f5275443--
