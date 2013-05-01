Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3EALMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:12:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48941 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759557Ab3EALLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:11:32 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shawn Guo <shawn.guo@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH 0/2] PM / OPP: updates to enable sharing OPPs info
Date: Wed,  1 May 2013 12:11:17 +0100
Message-Id: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.7.10.4
X-OriginalArrivalTime: 01 May 2013 11:11:28.0752 (UTC) FILETIME=[A0B5AF00:01CE465C]
X-MC-Unique: 113050112113000301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r41BCLax029605

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

These are couple of updates to existing PM/OPP library to support
sharing of OPPs between different device nodes.

Currently all the cpu nodes are parsed until the OPPs are found. This
is essential to support cpuhotplug without having to replicate OPP
information in all the cpu nodes.

However in systems with multiple cpu power domain, its better to have
OPP entry for each cpu. To avoid replication, phandle can be specified
to the node which contains the full OPP information.

Sudeep KarkadaNagesha (2):
  PM / OPP: add support to specify phandle of another node for OPP
  PM / OPP: check for existing OPP list when initialising from device
    tree

 Documentation/devicetree/bindings/power/opp.txt |   41 +++++++++++++++++++++++
 drivers/base/power/opp.c                        |   35 ++++++++++++++-----
 2 files changed, 68 insertions(+), 8 deletions(-)

-- 
1.7.10.4


