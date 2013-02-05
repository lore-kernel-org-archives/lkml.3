Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3BEVCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:02:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:36221 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab3BEVCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:02:20 -0500
Message-ID: <1360098093.4529.14.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Date: Wed, 06 Feb 2013 08:01:33 +1100
In-Reply-To: <7613336.0C5oRATusX@wuerfel>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
	 <51111133.7000105@synopsys.com> <7613336.0C5oRATusX@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 16:12 +0100, Arnd Bergmann wrote:
> Ok. In this case, I would recommend making the default for this driver
> little-endian, and adding a quirk for broken hardware bridges like the
> one you cited to have a mixed-endian mode if configured so at compile
> time.
> 
> It seems that on all normal platforms, this device should behave as
> little-endian, while the Xilinx bridge can be either big-endian
> or little-endian, depending on whether it is used in 8-bit or 16-bit
> mode, so if we are using this, it cannot be known at compile time.

Why ? 8-bit devices shouldn't need anything special. 16-bit should be
wired properly to not need anything special either. Why would we bother
supporting a bad wiring ? Let them feel the pain, with luck it will
provide incentive for them to fix it.

Ben.


