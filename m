Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898Ab3DKXRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:17:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933854Ab3DKXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:16:22 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=4xt6Fo0EWj0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hMEebOuZuFAA:10 a=xsSHeAReS3act2xTqcwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411231149.302144972@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 19:11:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 0/9 ] 3.6.11.2-stable review (update)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As recommend by Eric W. Biederman, I removed:

  ipc: Restrict mounting the mqueue filesystem
    [a636b702ed1805e988ad3d8ff8b52c060f8b341c]
  vfs: Add a mount flag to lock read only bind mounts
    [90563b198e4c6674c63672fae1923da467215f45]

As recommend by Bing Zhao, I removed:

  mwifiex: fix race when queuing commands
    [00d7ea11ff0783e24fe70778f3141270b561aaa1]
  mwifiex: skip pending commands after function shutdown

As recommended by Ben Hutchings, I added:

Ben Hutchings (8):
      sfc: Disable soft interrupt handling during efx_device_detach_sync()
      sfc: Really disable flow control while flushing
      sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
      sfc: Add parentheses around use of bitfield macro arguments
      sfc: Fix MCDI structure field lookup
      sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
      sfc: Correctly initialise reset_method in siena_test_chip()
      sfc: Fix timekeeping in efx_mcdi_poll()

Daniel Pieczko (1):
      sfc: Work-around flush timeout when flushes have completed

----
 drivers/net/ethernet/sfc/bitfield.h    |   22 ++++++------
 drivers/net/ethernet/sfc/efx.h         |    4 +--
 drivers/net/ethernet/sfc/falcon.c      |    2 ++
 drivers/net/ethernet/sfc/mcdi.c        |   33 +++++++++++-------
 drivers/net/ethernet/sfc/mcdi.h        |    6 ++--
 drivers/net/ethernet/sfc/net_driver.h  |    3 ++
 drivers/net/ethernet/sfc/nic.c         |   59 ++++++++++++++++++++++++++++----
 drivers/net/ethernet/sfc/nic.h         |    2 ++
 drivers/net/ethernet/sfc/siena.c       |   17 +++++++--
 drivers/net/ethernet/sfc/siena_sriov.c |   13 ++++---
 10 files changed, 121 insertions(+), 40 deletions(-)
