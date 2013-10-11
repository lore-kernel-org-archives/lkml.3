Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3JKPSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:18:33 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:44166 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3JKPSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:18:31 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v2 0/2] Add support for Qualcomm's PRNG
Date: Fri, 11 Oct 2013 18:16:39 +0300
Message-Id: <1381504601-23773-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second version of RNG driver for MSM SoC's.

During the time since first version I've made some tests using
rng tools this is the result:

# cat /dev/hw_random | rngtest -c 100000

Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 2000000032
rngtest: FIPS 140-2 successes: 99925
rngtest: FIPS 140-2 failures: 75
rngtest: FIPS 140-2(2001-10-10) Monobit: 10
rngtest: FIPS 140-2(2001-10-10) Poker: 9
rngtest: FIPS 140-2(2001-10-10) Runs: 20
rngtest: FIPS 140-2(2001-10-10) Long run: 38
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=1.267; avg=53.222; max=2384.186)Mibits/s
rngtest: FIPS tests speed: (min=3.016; avg=48.847; max=49.931)Mibits/s
rngtest: Program run time: 75191914 microseconds

Changes since v1:

  * I took into account Stephen Boyd's comments about define duplication
and added a call to platform_get_resource.
  * The 'struct hwrng' is now embedded into msm_rng private structure to
avoid global variables and allow more than one instances of the driver.

===================================================================
This patch set adds hardware RNG driver wich is used to control the
Qualcomm's PRNG hardware block.
The first patch document the DT bindings needed to sucessfuly probe
the driver and the second patch adds the driver.

Comments are welecome!

Stanimir Varbanov (2):
  ARM: DT: msm: Add Qualcomm's PRNG driver binding document
  hwrng: msm: Add PRNG support for MSM SoC's

 .../devicetree/bindings/rng/qcom,prng.txt          |  17 ++
 drivers/char/hw_random/Kconfig                     |  12 ++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/msm-rng.c                   | 195 +++++++++++++++++++++
 4 files changed, 225 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/qcom,prng.txt
 create mode 100644 drivers/char/hw_random/msm-rng.c

-- 
1.8.3.1

