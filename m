Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3LPKc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:32:26 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63815 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab3LPKcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:32:25 -0500
Message-ID: <1387189942.9255.27.camel@x41.thuisdomein>
Subject: [PATCH 0/2] ahci: two fixes for ICH6
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Dec 2013 11:32:22 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2013 10:32:23.0379 (UTC) FILETIME=[1B5AEA30:01CEFA4A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two fixes were triggered by a warning printed by ahci on an
(outdated) ThinkPad X41. The first one silences that warning on ICH6-M
and ICH6R when running in "combined mode" (which disables ahci support).
The second one makes sure that ahci will only attach for ICH6-M if it's
running in SATA mode.

Tested on top of v3.13-rc4.

Paul Bolle (2):
  ahci: bail out on ICH6 before using AHCI BAR
  ahci: only attach ICH6-M if it's in SATA mode

 drivers/ata/ahci.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

-- 
1.8.1.4

