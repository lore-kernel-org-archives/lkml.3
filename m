Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaKUR5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:57:40 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21079
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbaKUR5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:57:39 -0500
X-IronPort-AV: E=Sophos;i="5.07,432,1413237600"; 
   d="scan'208";a="89924497"
Date: Fri, 21 Nov 2014 18:59:00 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: USB: serial: Deletion of an unnecessary check before the function
 call "release_firmware"
In-Reply-To: <546F5ED7.1000206@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1411211857590.2433@hadrien>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <546F5831.5060404@users.sourceforge.net> <alpine.DEB.2.10.1411211625380.2433@hadrien> <546F5ED7.1000206@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Nov 2014, SF Markus Elfring wrote:

> >> diff --git a/drivers/usb/serial/mxuport.c b/drivers/usb/serial/mxuport.c
> >> index ab1d690..3653ec1 100644
> >> --- a/drivers/usb/serial/mxuport.c
> >> +++ b/drivers/usb/serial/mxuport.c
> >> @@ -1101,8 +1101,7 @@ static int mxuport_probe(struct usb_serial *serial,
> >>  	 */
> >>  	usb_set_serial_data(serial, (void *)id->driver_info);
> >>  out:
> >> -	if (fw_p)
> >> -		release_firmware(fw_p);
> >> +	release_firmware(fw_p);
> >
> > I think that the if should stay.
>
> I have got an other opinion.
>
>
> > There were two cases on the allocation, so there should be two cases
> > on the release.
>
> I find that this implementation detail does not really matter for the
> necessity of a null pointer check directly before such a function call.

Conceptually, if it is clear 10 lines above that nothing was allocated,
and there is a fallback to existing data (according to the comment above)
it is strange to be releasing something.

julia
