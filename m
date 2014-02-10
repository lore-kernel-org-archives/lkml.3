Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaBJPwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:52:36 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:56883 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBJPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:52:30 -0500
Date: Mon, 10 Feb 2014 16:54:36 +0100
From: Emil Goode <emilgoode@gmail.com>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>, "David S. Miller" <davem@davemloft.net>,
        Ming Lei <ming.lei@canonical.com>, Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] usbnet: fix bad header length bug
Message-ID: <20140210155436.GA4258@lianli>
References: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
 <1392014458.21271.6.camel@linux-fkkt.site>
 <20140210115812.GA4278@lianli>
 <1392034947.2082.30.camel@linux-fkkt.site>
 <87iosn86en.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87iosn86en.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:05:20PM +0100, Bjørn Mork wrote:
> Oliver Neukum <oliver@neukum.org> writes:
> > On Mon, 2014-02-10 at 13:00 +0100, Emil Goode wrote:
> >> On Mon, Feb 10, 2014 at 07:40:58AM +0100, Oliver Neukum wrote:
> >
> >> > Well, then how about simply removing the check?
> >> > It seems to have outlived its usefulness.
> >> > 
> >> > 	Regards
> >> > 		Oliver
> >> > 
> >> >
> >> 
> >> I did consider that and I think it is probably the best thing to do.
> >> However, I think the removal of the check could have negative effects
> >> on the other minidrivers, at least the qmi_wwan minidriver explicitly
> >> states that it is depending on this check to be made in rx_complete().
> >
> > <censored>.
> 
> No need to do that.  I had the exact same reaction myself :-)
> 
> Anyway, I put that comment there mostly as a note to myself why the
> check would be redundant at that point.  I don't see any problem with
> removing the generic check in usbnet as long as we add similar checks
> whereever they are needed, like in qmi_wwan.

I think it could be worth the trouble of removing the generic check in
the usbnet module.

I believe that if you define your own rx_fixup callback then the
usbnet module should not make it's own assumptions on what packets 
to discard.

Since the checks that need to be added in various places are all in
the same subsystem I think it could be done in as little as one patch?

> Note that usbnet_skb_return will be one of those places.  It calls
> eth_type_trans() on the skb, so it should verify that the length is at
> least ETH_HLEN first.
> 
> > Oh well. But how about merging it with FLAG_MULTI_PACKET?
> > I really don't want to add more flags. There is a point where enough
> > flags make absurd having a common code. We are closing in on that point.
> 
> Agreed.  I would even say we are past that point...

If nobody have any objections I will try removing the generic check and
introduce checks where nessecary.

Best regards,

Emil Goode
