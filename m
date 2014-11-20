Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbaKTOms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:42:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40164 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbaKTOmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:42:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 20 Nov 2014 15:41:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] [media] firewire: Deletion of an unnecessary check
 before the function call "dvb_unregister_device"
Message-ID: <20141120154148.724ab462@kant>
In-Reply-To: <546DBA8E.6080401@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546DBA8E.6080401@users.sourceforge.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20 SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 20 Nov 2014 10:49:07 +0100
> 
> The dvb_unregister_device() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> ---
>  drivers/media/firewire/firedtv-ci.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
> index e5ebdbf..e63f582 100644
> --- a/drivers/media/firewire/firedtv-ci.c
> +++ b/drivers/media/firewire/firedtv-ci.c
> @@ -253,6 +253,5 @@ int fdtv_ca_register(struct firedtv *fdtv)
>  
>  void fdtv_ca_release(struct firedtv *fdtv)
>  {
> -	if (fdtv->cadev)
> -		dvb_unregister_device(fdtv->cadev);
> +	dvb_unregister_device(fdtv->cadev);
>  }



-- 
Stefan Richter
-=====-====- =-== =-=--
http://arcgraph.de/sr/
