Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaJFJHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:07:04 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:63478 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbaJFJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:07:00 -0400
Message-ID: <1412586417.4054.38.camel@x220>
Subject: [PATCH 0/4] Remove optional dependencies on PLAT_S5P
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 11:06:57 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 09:06:57.0549 (UTC) FILETIME=[E191D3D0:01CFE144]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
removed the Kconfig symbol PLAT_S5P. The seven dependencies on that
symbol have evaluated to false since next-20140716 (for linux-next) and
v3.17-rc1 (for mainline). Probably no one noticed because these are all
optional dependencies.

I've mentioned this a few times:
- http://lkml.kernel.org/r/1405505756.4408.24.camel@x220
- http://lkml.kernel.org/r/1409825817.5546.99.camel@x220
- http://lkml.kernel.org/r/1411068565.2017.83.camel@x220

As far as I know no fix for this is pending. So let's remove these
optional dependencies. If it turns out that they should actually be
replaced by another symbol, as was said in a reply to my first message
but never done, this series can be used as a reference for the places
that need fixing.

This series is done on top of next-20141003. It is tested by grepping
the tree only.

Paul Bolle (4):
  [media] Remove optional dependencies on PLAT_S5P
  [media] exynos4-is: Remove optional dependency on PLAT_S5P
  [media] Remove optional dependency on PLAT_S5P
  usb: host: Remove optional dependencies on PLAT_S5P

 drivers/media/platform/Kconfig            | 6 +++---
 drivers/media/platform/exynos4-is/Kconfig | 2 +-
 drivers/media/platform/s5p-tv/Kconfig     | 2 +-
 drivers/usb/host/Kconfig                  | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
1.9.3

