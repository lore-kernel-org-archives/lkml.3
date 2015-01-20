Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbbATL5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:57:15 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:40962 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbbATL5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:57:12 -0500
Date: Tue, 20 Jan 2015 11:56:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
Message-ID: <20150120115658.GJ26493@n2100.arm.linux.org.uk>
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
 <1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
 <20150119091705.GG21886@x1>
 <87ppaah9k5.fsf@free.fr>
 <20150120102919.GP5767@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120102919.GP5767@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:29:19AM +0000, Lee Jones wrote:
> On Mon, 19 Jan 2015, Robert Jarzmik wrote:
> > >> +	if (ret) {
> > >> +		dev_err(&pdev->dev, "Couldn't request main irq : ret = %d\n",
> > >> +			ret);
> > >
> > > I'm not keen on this type of formatting.  Besides the system will
> > > print out the returned error on failure.
> > Well, it will print -EINVAL or -ENODEV. When I'll receive an request on the
> > driver with -ENODEV, how will I know it will come from this request_irq() or
> > another part of the code ... Well I can remove it if you want, but I think it's
> > an error.
> 
> I'm not asking you to remove the entire message, just the junk at the
> end.

No.  Leave it.  If request_irq() returns -ENODEV or -ENXIO, you'll
just get the "Couldn't request main irq" message but without the
error code printed.

What I'd suggest (and always have done) is:

	dev_err(&pdev->dev, "couldn't request main irq%d: %d\n",
		irq, ret);

but I guess printing the IRQ number no longer makes sense with todays
dynamic mapping of logical IRQ numbers, as it is no longer meaningful.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
