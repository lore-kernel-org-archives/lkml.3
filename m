Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaDFR62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:58:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33869 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaDFR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:58:26 -0400
Date: Sun, 6 Apr 2014 18:58:18 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
Cc: "Du, Wenkai" <wenkai.du@intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
In-Reply-To: <20140405061316.GF19349@intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
	<20140404181613.GB19349@intel.com>
	<7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
	<20140404184232.GC19349@intel.com>
	<7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
	<20140405061316.GF19349@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2014 09:13:16 +0300
"Westerberg, Mika" <mika.westerberg@intel.com> wrote:

> On Sat, Apr 05, 2014 at 12:54:33AM +0300, Du, Wenkai wrote:
> > >Interrupt masking is done already after each transaction.
> > 
> > At end of transfer, the code uses __i2c_dw_enable(dev, false) to disable
> > adapter. This function doesn't mask interrupts. There is another function
> > i2c_dw_disable that masks and clears interrupts. This could be used, but
> > that means we need to fix in 2 places: 
> 
> Please check i2c_dw_isr() and tell me in which code path interrupts are not
> getting masked. Or am I missing something fundamental here?
> 
> In case of abort, we mask interrupts. Also whenever the transaction
> completes we mask interrupts (in i2c_dw_xfer_msg()).

Well actually you mask the IRQ at some point after the function returns
if the bus allows the write to be posted. As i2c_dw_isr can then exit the
IRQ handler before the write completes I suspect you have a race ?

Alan
