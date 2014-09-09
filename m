Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaIIBmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:42:04 -0400
Received: from linuxhacker.ru ([217.76.32.60]:35850 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348AbaIIBmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:42:00 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Hugues <morisset.hugues@gmail.com>, Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 0/2] Lustre: get rid of is_osp_on_mdt
Date: Mon,  8 Sep 2014 21:41:26 -0400
Message-Id: <1410226888-20377-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugues <morisset.hugues@gmail.com> has recently discovered a possibility
of buffer underflow in is_osp_on_mdt.
Instead of fixing it up, let's just get rid of this function altogether,
since it's no longer needed.

Mikhail Pershin (1):
  staging/lustre: use osc_reply_portal for OUT services

Oleg Drokin (1):
  staging/lustre: remove unused function is_osp_on_mdt

 drivers/staging/lustre/lustre/fld/fld_request.c    |  1 +
 .../lustre/lustre/include/lustre/lustre_idl.h      |  2 +-
 drivers/staging/lustre/lustre/include/obd.h        | 29 ----------------------
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      | 29 ++++++++++++++--------
 4 files changed, 20 insertions(+), 41 deletions(-)

-- 
1.9.3

