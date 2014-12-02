Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaLBABq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:01:46 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54771 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaLBABo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:01:44 -0500
MIME-Version: 1.0
In-Reply-To: <5479E693.3010200@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <5479E693.3010200@users.sourceforge.net>
From: Mahesh Bandewar <maheshb@google.com>
Date: Mon, 1 Dec 2014 16:01:23 -0800
Message-ID: <CAF2d9ji2FRX0hdh-R-PQZoNG59s+74Tff=BeAHfhTtLo590-rw@mail.gmail.com>
Subject: Re: [PATCH 1/1] net-ipvlan: Deletion of an unnecessary check before
 the function call "free_percpu"
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 7:30 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 29 Nov 2014 16:23:20 +0100
>
> The free_percpu() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Mahesh Bandewar <maheshb@google.com>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index 96b71b0..feb1853 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -125,8 +125,7 @@ static void ipvlan_uninit(struct net_device *dev)
>         struct ipvl_dev *ipvlan = netdev_priv(dev);
>         struct ipvl_port *port = ipvlan->port;
>
> -       if (ipvlan->pcpu_stats)
> -               free_percpu(ipvlan->pcpu_stats);
> +       free_percpu(ipvlan->pcpu_stats);
>
>         port->count -= 1;
>         if (!port->count)
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
