Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3HaDqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 23:46:08 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49544 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3HaDqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 23:46:06 -0400
Message-ID: <1377921190.32763.327.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL -v2] target fixes for v3.11
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>, CAD <cad.ext@larioja.org>
Date: Fri, 30 Aug 2013 20:53:10 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a -v2 PULL request for the current set of target-pending fixes
for v3.11.  These fixes have not hit mainline yet, so I'm resending them
now to be sure they hit v3.11 before the merge window opens.  Please let
me know if you have any concerns with the series.

The original PULL request from last Saturday is here:

http://marc.info/?l=linux-kernel&m=137737916904812&w=2

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The first patch is to address a long standing issue where INQUIRY vendor
+ model response data was not correctly padded with ASCII spaces,
causing MSFT and Falconstor multipath stacks to not function with our
LUNs.

The remaining patches are additional iscsi-target regression fixes for
the post >= v3.10 iser-target changes.  The second and third are failure
cases that have appeared during further testing, and the forth is only
reproducible with malformed NOP packets.

The last three patches are CC'ed to stable, and the first one will be
sent to Greg-KH separately.

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

