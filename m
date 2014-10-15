Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaJOSYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:24:22 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44027 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaJOSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <1413394958.2412.23.camel@jtkirshe-mobl>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	<20141015123431.GA23154@mwanda>
	<20141015125934.GB23154@mwanda>
	<1413378213.2412.13.camel@jtkirshe-mobl>
	<1413389496.7484.3.camel@perches.com>
	<1413394958.2412.23.camel@jtkirshe-mobl>
Date: Wed, 15 Oct 2014 15:24:19 -0300
Message-ID: <CAOMZO5C5ya=OgBUEOOM+tZE7B2zZ3J05PHC14t3Tp6nXkPYmoQ@mail.gmail.com>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Fabio Estevam <festevam@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 2:42 PM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:

> I like the idea, but won't this exclude other 32 bit systems like MIPS
> and I am sure there might be others.  I could assume that Beceem WIMAX
> was intended for x86 arch's that are 32 bit only, which may be a safe
> bet.  The only thing we know for sure is that is broken on 64bit.

What about this?

diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
index 8acf4b2..fa5a3a4 100644
--- a/drivers/staging/bcm/Kconfig
+++ b/drivers/staging/bcm/Kconfig
@@ -1,6 +1,6 @@
 config BCM_WIMAX
        tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
-       depends on USB && NET
+       depends on USB && NET && !64BIT
        help
          This is an experimental driver for the Beceem WIMAX chipset used
         by Sprint 4G.
