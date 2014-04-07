Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaDGOnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:43:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34575 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaDGOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:43:00 -0400
Date: Mon, 7 Apr 2014 15:42:52 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
Cc: "Du, Wenkai" <wenkai.du@intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140407154252.6b8f0f7e@alan.etchedpixels.co.uk>
In-Reply-To: <20140407090403.GG19349@intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
	<20140404181613.GB19349@intel.com>
	<7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
	<20140404184232.GC19349@intel.com>
	<7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
	<20140405061316.GF19349@intel.com>
	<20140406185818.3aaca03d@alan.etchedpixels.co.uk>
	<20140407090403.GG19349@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had to check BYT specs about that and I couldn't find if it does
> posted-writes. 

Then I would assume it does unless you can find a hardware engineer to
sign a statement in blood to that effect 8)

> Actually the following patch should fix the problem as well. Just move the
> HW enable to happen last. That way we can make sure that there is a valid
> interrupt mask programmed before the controller is enabled.

This fixes the init case, it doesn't fix the question about returning
from the IRQ before the mask write takes effect and thus taking another
interrupt.

Alan
