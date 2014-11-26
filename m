Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaKZED3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:03:29 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46903 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaKZED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:03:27 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19G6SglQfuXi0s/QmnZQqEQiBM8Tkt0CiQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 36CF9623F96
Date: Tue, 25 Nov 2014 23:03:16 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 08/16] clk: mvebu: add suspend/resume for gatable
 clocks
Message-ID: <20141126040316.GK22670@titan.lakedaemon.net>
References: <1416585613-2113-1-git-send-email-thomas.petazzoni@free-electrons.com>
 <1416585613-2113-9-git-send-email-thomas.petazzoni@free-electrons.com>
 <20141125060700.12298.14532@quantum>
 <20141125074801.1656b78b@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125074801.1656b78b@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 07:48:01AM +0100, Thomas Petazzoni wrote:
> Mike,
> 
> On Mon, 24 Nov 2014 22:07:00 -0800, Mike Turquette wrote:
> > Quoting Thomas Petazzoni (2014-11-21 08:00:05)
> > > This commit adds suspend/resume support for the gatable clock driver
> > > used on Marvell EBU platforms. When getting out of suspend, the
> > > Marvell EBU platforms go through the bootloader, which re-enables all
> > > gatable clocks. However, upon resume, the clock framework will not
> > > disable again all gatable clocks that are not used.
> > > 
> > > Therefore, if the clock driver does not save/restore the state of the
> > > gatable clocks, all gatable clocks that are not claimed by any device
> > > driver will remain enabled after a resume. This is why this driver
> > > saves and restores the state of those clocks.
> > > 
> > > Since clocks aren't real devices, we don't have the normal ->suspend()
> > > and ->resume() of the device model, and have to use the ->suspend()
> > > and ->resume() hooks of the syscore_ops mechanism. This mechanism has
> > > the unfortunate idea of not providing a way of passing private data,
> > > which requires us to change the driver to make the assumption that
> > > there is only once instance of the gatable clock control structure.
> > > 
> > > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > > Cc: Mike Turquette <mturquette@linaro.org>
> > > Cc: linux-kernel@vger.kernel.org
> > > Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > 
> > Looks good to me. Which tree do you plan to take this through?
> 
> I don't have any specific plans. Jason, do you have other clk changes
> for 3.19, which justify a pull request from you to Mike? Or could Mike
> just take this patch in his tree? There is no build dependency between
> this patch and the other patches in the series, so it can go through
> whatever tree.

Well, I pulled the whole series into mvebu/soc-suspend to give it some
time in -next.  It'd be easiest, with my current schedule, to send a
PR for it as-is.  If that's ok with Mike, I'd appreciate it.  Obviously,
I wouldn't make a habit of it... :-P

thx,

Jason.
