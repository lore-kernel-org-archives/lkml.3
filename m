Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3HXVTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:19:16 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:60060 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3HXVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:19:15 -0400
Message-ID: <1377379570.32763.122.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL] target fixes for v3.11-rc7
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 24 Aug 2013 14:26:10 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the current set of target-pending fixes for v3.11-rc7.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The first patch is to address a long standing issue where INQUIRY vendor
+ model response data was not correctly padded with ASCII spaces,
causing one particular multipath stack to not function with our LUNs.

The remaining patches are additional iscsi-target regression fixes for
the post >= v3.10 iser-target changes.  The second and third are failure
cases that have appeared during further testing, and the forth is only
reproducible with malformed packets.

Thank you,

--nab

Nicholas Bellinger (4):
  target: Fix trailing ASCII space usage in INQUIRY vendor+model
  iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10
  iscsi-target: Fix iscsit_transport reference leak during NP thread
    reset
  iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject

 drivers/target/iscsi/iscsi_target.c       |   17 ++++++++++-------
 drivers/target/iscsi/iscsi_target_login.c |    9 ++++-----
 drivers/target/target_core_spc.c          |    9 ++++++---
 3 files changed, 20 insertions(+), 15 deletions(-)

