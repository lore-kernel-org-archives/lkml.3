Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3LODmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:42:00 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46154 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3LODl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:41:58 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 19:41:49 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Miller <davem@davemloft.net>
Cc: rashika.kheria@gmail.com, linux-kernel@vger.kernel.org,
        sebastian@breakpoint.cc, sachin.kamat@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/9] drivers: net: Put prototype declaration for
 function sbni_probe() in sbni.c
Message-ID: <20131215034148.GA1573@leaf>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
 <dd984c99d43214c39b23f95e9a58f3a675147e69.1386911124.git.rashika.kheria@gmail.com>
 <20131214.222658.766340465002992773.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214.222658.766340465002992773.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 10:26:58PM -0500, David Miller wrote:
> From: Rashika Kheria <rashika.kheria@gmail.com>
> Date: Sat, 14 Dec 2013 17:55:42 +0530
> 
> > This patch declares the prototype for the function sbni_probe() in file sbni.c.
> > 
> > Thus, it also removes the following warning in wan/sbni.c:
> > drivers/net/wan/sbni.c:224:12: warning: no previous prototype for ‘sbni_probe’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > ---
> > 
> > This revision fixes the following issues of the previous revision:
> > Incorrect fix
> > 
> >  drivers/net/wan/sbni.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
> > index 388ddf6..5061ffd 100644
> > --- a/drivers/net/wan/sbni.c
> > +++ b/drivers/net/wan/sbni.c
> > @@ -221,6 +221,7 @@ static void __init sbni_devsetup(struct net_device *dev)
> >  	dev->netdev_ops = &sbni_netdev_ops;
> >  }
> >  
> > +int __init sbni_probe(int unit);
> >  int __init sbni_probe(int unit)
> 
> This is not the correct way to fix this kind of warning, an exported
> function needs to appear in a header file so that both the definition
> and any callers of this function will see the same declaration in that
> header file.

It should, yes; however, in this case, the function is one of several
dozen that are directly prototyped and used by drivers/net/Space.c, and
there's no header file prototyping any of those functions.

Do you have a suggestion for what header file should contain a prototype
for this probe function?

- Josh Triplett
