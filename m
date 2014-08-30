Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaH3Kt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:49:56 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57561 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaH3Ktz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:49:55 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: handle -EPROBE_DEFER in of_iio_channel_get_by_name
Date: Sat, 30 Aug 2014 12:51:55 +0200
Message-ID: <1889900.9ty4gGSZCE@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <5401A770.3040204@kernel.org>
References: <4420839.L1RSpT2Pjo@diego> <5401A770.3040204@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 30. August 2014, 11:29:04 schrieb Jonathan Cameron:
> On 28/08/14 23:13, Heiko Stübner wrote:
> > Till now of_iio_channel_get_by_name always tried to find the channel
> > without evaluating the return code from of_iio_channel_get. This might
> > include -EPROBE_DEFER in which case the channel is present but its driver
> > simply not probed yet. Therefore simply return on -EPROBE_DEFER so that
> > the driver requesting the channel can also defer.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> I already have a patch queued up for this change in the fixes-togreg branch
> 
> [PATCH] iio:inkern: fix overwritten -EPROBE_DEFER in
> of_iio_channel_get_by_name by Johannes Pointner
> 
> I'm just being a little slow catching up with patches at the moment.

no problem ... at least the issue got fixed :-)


> 
> J
> 
> > ---
> > 
> >  drivers/iio/inkern.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> > index c749700..f084610 100644
> > --- a/drivers/iio/inkern.c
> > +++ b/drivers/iio/inkern.c
> > @@ -178,7 +178,7 @@ static struct iio_channel
> > *of_iio_channel_get_by_name(struct device_node *np,> 
> >  			index = of_property_match_string(np, "io-channel-names",
> >  			
> >  							 name);
> >  		
> >  		chan = of_iio_channel_get(np, index);
> > 
> > -		if (!IS_ERR(chan))
> > +		if (!IS_ERR(chan) || PTR_ERR(chan) == -EPROBE_DEFER)
> > 
> >  			break;
> >  		
> >  		else if (name && index >= 0) {
> >  		
> >  			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",

