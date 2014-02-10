Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBJMWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:22:31 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:50274 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaBJMWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:22:30 -0500
Message-ID: <1392034947.2082.30.camel@linux-fkkt.site>
Subject: Re: [PATCH 1/2 v2] usbnet: fix bad header length bug
From: Oliver Neukum <oliver@neukum.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 13:22:27 +0100
In-Reply-To: <20140210115812.GA4278@lianli>
References: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
	 <1392014458.21271.6.camel@linux-fkkt.site> <20140210115812.GA4278@lianli>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 13:00 +0100, Emil Goode wrote:
> On Mon, Feb 10, 2014 at 07:40:58AM +0100, Oliver Neukum wrote:
> > On Mon, 2014-02-10 at 00:06 +0100, Emil Goode wrote:
> > > The AX88772B occasionally send rx packets that cross urb boundaries
> > > and the remaining partial packet is sent with no hardware header.
> > > When the buffer with a partial packet is of less number of octets
> > > than the value of hard_header_len the buffer is discarded by the
> > > usbnet module. This is causing dropped packages and error messages
> > > in dmesg.
> > > 
> > > This can be reproduced by using ping with a packet size
> > > between 1965-1976.
> > 
> > Well, then how about simply removing the check?
> > It seems to have outlived its usefulness.
> > 
> > 	Regards
> > 		Oliver
> > 
> >
> 
> I did consider that and I think it is probably the best thing to do.
> However, I think the removal of the check could have negative effects
> on the other minidrivers, at least the qmi_wwan minidriver explicitly
> states that it is depending on this check to be made in rx_complete().

<censored>. Oh well. But how about merging it with FLAG_MULTI_PACKET?
I really don't want to add more flags. There is a point where enough
flags make absurd having a common code. We are closing in on that point.

	Regards
		Oliver


