Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaANSDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:03:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaANSB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:01:28 -0500
Date: Tue, 14 Jan 2014 10:02:04 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCHv2] driver core/platform: don't leak memory allocated for
 dma_mask
Message-ID: <20140114180204.GD27791@kroah.com>
References: <1386886207-2735-1-git-send-email-ydroneaud@opteya.com>
 <1389649085-7365-1-git-send-email-ydroneaud@opteya.com>
 <20140113225606.GA4132@kroah.com>
 <1389683909-17495-1-git-send-email-ydroneaud@opteya.com>
 <20140114081944.GO29475@pengutronix.de>
 <1389693453.1585.26.camel@localhost.localdomain>
 <20140114103648.GT29475@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140114103648.GT29475@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:36:48AM +0100, Uwe Kleine-König wrote:
> > I will try to get some figure on the number of platform_device
> > registered with a dmamask versus without a dmamask: adding the u64 to
> > all platform_object might cost more memory than the extra code (1 branch
> > and a function).
> Also take into account
> 
> 	sizeof(struct platform_object) + strlen(average device)
> 
> Before and after the change. ISTR that the first summand is ~300 (on
> ARM). With putting dma_mask unconditionally into platform_object this
> goes up by 8, IMHO that is OK.
> 
> In return you save that alignment hassle and both your patch and the
> resulting code become simpler.

Yes, please do it this way, it makes it more obvious as to exactly what
is going on, which is more valuable than trying to be "tricky" and save
a few bytes of ram or rom.

thanks,

greg k-h
