Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3EVMkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:40:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab3EVMki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:40:38 -0400
Subject: RapidIO subsystem and modularity
From: Jean Delvare <jdelvare@suse.de>
To: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 22 May 2013 14:40:30 +0200
Message-ID: <1369226430.4718.123.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, Alexandre, Andrew,

At the moment all pieces of the RapidIO subsystem are defined as bool
and thus cannot be built as modules. This is a problem for distribution
kernels, which are left with only two choices: disable RapidIO
altogether (too bad if any user actually needed it), or enable it all
(and waste memory and initialization time for every user without the
hardware - most users as I understand it.)

I don't even know what RapidIO is good for. I read about it on the web
but I have to admit I still have no clear idea, what systems use this
technology.

This leads me to two questions:

1* Is there a fundamental reason why (at least the device-specific parts
of) RapidIO can't be modularized?

FWIW I tried making the device drivers (tsi721) modular and it builds
and links OK, but I suppose one would have implement a proper remove
function, otherwise module unloading will break.

I also tried making the switch drivers (tsi57x etc.) modular, all build
just fine without any change, but there seems to be some initialization
magic which may not work when the code is built as modules.

2* What systems are expected to use RapidIO? It is enabled in the i386,
x86_64, ppc and ppc64 generic openSUSE kernel configurations. If someone
tells me that some or all of these generic kernels would never be used
on systems which need RapidIO support, I would be happy to disable
RapidIO support from these kernels, to make them smaller and decrease
boot times.

Thanks for any insight,
-- 
Jean Delvare
Suse L3

