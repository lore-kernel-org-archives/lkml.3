Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab3BZQK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:10:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33343 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958Ab3BZQKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:10:54 -0500
Date: Tue, 26 Feb 2013 10:10:49 -0600
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.9-rc1
Message-ID: <20130226161049.GA9303@kahuna>
References: <1663657.ypAtqGpGAq@vostro.rjw.lan>
 <1781256.mPQbtiUPYR@vostro.rjw.lan>
 <CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com>
 <2223198.XmyRLgb3Gv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2223198.XmyRLgb3Gv@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:55-20130226, Rafael J. Wysocki wrote:
> On Monday, February 25, 2013 09:31:45 PM Linus Torvalds wrote:
> > On Mon, Feb 25, 2013 at 7:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
[..]
> 
> > This has become a huge problem, to the point that we have a
> > "Documentation/power/opp.txt" file THAT NEVER CLEARLY STATES WHAT THE
> > F*CK OPP ACTUALLY MEANS! What nice "documentation".
> 
> It says that in "Introduction", but it would be clearer if the title of the
> doc was something like "Operating Performance Points (OPP) Library".  Nishanth?
Yes indeed. Will the following help? I can post it as an official patch
if the direction is proper.
diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index 3035d00..4a17443 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -1,5 +1,5 @@
 *=============*
-* OPP Library *
+* Operating Performance Points (OPP) Library *
 *=============*
 
 (C) 2009-2010 Nishanth Menon <nm@ti.com>, Texas Instruments Incorporated
@@ -16,6 +16,8 @@ Contents
 
 1. Introduction
 ===============
+1.1 What is an Operating Performance Point (OPP)?
+
 Complex SoCs of today consists of a multiple sub-modules working in conjunction.
 In an operational system executing varied use cases, not all modules in the SoC
 need to function at their highest performing frequency all the time. To
@@ -25,6 +27,16 @@ more. The set of discrete tuples consisting of frequency and voltage pairs that
 the device will support per domain are called Operating Performance Points or
 OPPs.
 
+As an example:
+MPU device supports {300MHz at minimum voltage of 1V}, {800MHz at minimum
+voltage of 1.2V}, {1GHz at minimum voltage of 1.3V}
+We can represent these as three OPPs
+{300000, 1000000}
+{800000, 1200000}
+{1000000, 1300000}
+
+1.2 Operating Performance Points Library
+
 OPP library provides a set of helper functions to organize and query the OPP
 information. The library is located in drivers/base/power/opp.c and the header
 is located in include/linux/opp.h. OPP library can be enabled by enabling

-- 
Regards,
Nishanth Menon
