Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815Ab3CLXPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:15:31 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33554 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab3CLXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:15:26 -0400
Date: Tue, 12 Mar 2013 16:15:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Simon Baatz <gmbnomis@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [ 33/40] rtc: rtc-mv: Add support for clk to avoid lockups
Message-ID: <20130312231523.GB21836@kroah.com>
References: <20130312223211.492954675@linuxfoundation.org>
 <20130312223214.995095830@linuxfoundation.org>
 <20130312230843.GK12700@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312230843.GK12700@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 07:08:43PM -0400, Jason Cooper wrote:
> Greg,
> 
> On Tue, Mar 12, 2013 at 03:43:54PM -0700, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > commit 89c58c198b252f2bc20657fdd72a2aea788c435c upstream.
> > 
> > The Marvell RTC on Kirkwood makes use of the runit clock. Ensure the
> > driver clk_prepare_enable() this clock, otherwise there is a danger
> > the SoC will lockup when accessing RTC registers with the clock
> > disabled.
> > 
> > Reported-by: Simon Baatz <gmbnomis@gmail.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > Tested-by: Simon Baatz <gmbnomis@gmail.com>
> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  arch/arm/boot/dts/kirkwood.dtsi |    1 +
> >  drivers/rtc/rtc-mv.c            |   28 ++++++++++++++++++++++++----
> >  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> Please drop from 3.4-stable.  devm_clk_get() wasn't available.

Now dropped.

