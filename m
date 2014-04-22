Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbaDVO1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:27:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53256 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaDVO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:27:49 -0400
Date: Tue, 22 Apr 2014 15:27:23 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spi/pxa2xx-pci: Pass host clock rate info from PCI
 glue layer
Message-ID: <20140422152723.7542a3bc@alan.etchedpixels.co.uk>
In-Reply-To: <20140422120948.GT12304@sirena.org.uk>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
	<1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
	<20140418163054.GH12304@sirena.org.uk>
	<20140422115716.GP30677@intel.com>
	<20140422120948.GT12304@sirena.org.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is this conditional?  It's really unhelpful for writing generic code
> handling clocks that the API isn't available as standard.  Allowing the
> user to disable it if it's not required makes sense but not making it
> available at all is just unhelpful.

KConfig allows drivers to select features they need - this seems to be a
non issue ?

> As far as I can tell the clock here is part of the same glue that allows
> the generic pxa2xx support to be instantiated from PCI.  I would
> therefore expect the glue to also instantiate the clock.  Or if it's a
> standard PCI clock then perhaps the PCI subsystem ought to be providing
> it.

For most cases it probably makes sense to do something of that form,
although as clk_enable/clk_disable allow NULL it's much less of an issue
than it might otherwise be for some of the other drivers.

Alan

