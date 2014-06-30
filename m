Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaF3Isb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:48:31 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:56877 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbaF3Isa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:48:30 -0400
Date: Mon, 30 Jun 2014 12:47:39 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: gregkh@linuxfoundation.org
cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, matwey.kornilov@gmail.com
Subject: [PATCH 0/2] parport: parport_pc: Introduce option to disable checking
 for Intel bug
Message-ID: <alpine.LRH.2.00.1406301241590.15067@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Wed, 25 Jun 2014 00:53:54 +0400
Subject: [PATCH 0/2] parport: parport_pc: Introduce option to disable checking for Intel bug

Hi,

The following patch series is to deal with the issue on false-positives
of Intel EPP bug check [1].

More than a decade ago, the check was introduced in order to prevent EPP
operation on the some Intel LPT chipsets. The main issue to defence from
was CPU hang at EPP operation on broken chipsets. It is mentioned that
affected chipsets are Intel 82091. However, it is not known whether
there are others.

The check was implemented in a strange manner. Now, there is no explanations
why. The check itself now leads to the false-positives, disabling EPP on
many PC-s (Dell OptiPlex series for instance). The latter is an issue.

Given that our knowledge of the initial problem is quite limited now,
I introduce special option for parport_pc, allowing user to disable check.
This won't introduce regressions.

The patches organized as following:

1. Introduce-intel_bug_present-function.

The transparent refactoring of the check is performed.
Make the check be immutable regarding to ECR register.

2. Add force_epp module option for parport_pc.

Additional option `force_epp` for parport_pc is introduced.


The behaviour is the following:

modprobe parport_pc             # check is enabled, given there is no defaults
                                 # in /etc/modprobe.d/*
modprobe parport_pc force_epp=0 # check is enabled
modprobe parport_pc force_epp=1 # check is disabled


[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=630593

Tested-by: Heiko Andreas Sommer <hsommer@eso.org>
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>

