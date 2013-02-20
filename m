Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219Ab3BTLNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:13:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934627Ab3BTLM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:12:56 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 0/6] Improvements for ghes_edac
Date: Wed, 20 Feb 2013 08:12:46 -0300
Message-Id: <cover.1361358127.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series complements the previous one sent:
	http://comments.gmane.org/gmane.linux.kernel/1442178

It contains:

- a patch removing the GHES_PFX macro, as requested by Joe Perches;
- a patch adding copyright notes and an entry at MAINTAINERS
  for the new driver;
- a patch suggested by Borislav moving the error description to an
  structure;
- 3 patches improving the error report for GHES-driven errors.

Patches were tested using a 4 cores machine.

With the patches, a GHES error like this one:

{1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
{1}[Hardware Error]: APEI generic hardware error status
{1}[Hardware Error]: severity: 2, corrected
{1}[Hardware Error]: section: 0, severity: 2, corrected
{1}[Hardware Error]: flags: 0x01
{1}[Hardware Error]: primary
{1}[Hardware Error]: section_type: memory error
{1}[Hardware Error]: error_status: 0x0000000000000400
{1}[Hardware Error]: node: 3
{1}[Hardware Error]: card: 0
{1}[Hardware Error]: module: 1
{1}[Hardware Error]: device: 0
{1}[Hardware Error]: error_type: 18, unknown

Was properly mapped to EDAC printk engine as:

EDAC MC0: 1 CE reserved error (18) on unknown label (node:3 card:0 module:1 page:0x0 offset:0x0 grain:0 syndrome:0x0 - status(0x0000000000000400): Storage error in memory (DRAM))

And to the corresponding RAS trace event:

mc_event: 1 Corrected error: reserved error (18) on unknown label (mc:0 location:-1:-1:-1 address:0x00000000 grain:1 syndrome:0x00000000 APEI location: node:3 card:0 module:1 status(0x0000000000000400): Storage error in memory (DRAM))

Mauro Carvalho Chehab (6):
  ghes_edac: remove GHES_PFX macro
  ghes_edac: add a MAINTAINERS entry and copyrights
  edac: put all arguments for the raw error handling call into a struct
  ghes_edac: Make it compliant with UEFI spec 2.3.1
  edac: add support on ras_event for error type "Info"
  ghes_edac: Fix RAS tracing

 MAINTAINERS              |   7 ++
 drivers/edac/edac_core.h |  16 +--
 drivers/edac/edac_mc.c   | 126 ++++++++++--------------
 drivers/edac/ghes_edac.c | 249 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/edac.h     |  71 ++++++++++++++
 include/ras/ras_event.h  |   4 +-
 6 files changed, 352 insertions(+), 121 deletions(-)

-- 
1.8.1.2

