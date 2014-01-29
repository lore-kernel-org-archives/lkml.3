Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaA2O5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:57:36 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52851 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaA2O5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:57:32 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, gregkh@linuxfoundation.org,
        badarkhe.manish@gmail.com
Subject: [PATCH V4 0/2] devm_* API operation for fixed regulator
Date: Wed, 29 Jan 2014 20:27:26 +0530
Message-Id: <1391007448-26245-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* API operations for fixed regulator driver so that
driver core will manage resources.

Also, introduce a new API "devm_kstrdup" and used it in fixed
regulator driver to manage resources.

Changes since V3:
 1. Update "devm_kstrdup" function to remove "size" argument.
    Also,used "devm_kmalloc" instead of "devm_kzalloc".

Changes since V2:
 1. Update driver to use new API "devm_kstrdup" instead of
    "kstrdup".
 2. Added a seperate patch to introduce new API "devm_kstrdup"

Changes since V1:
 1. Updated driver to use "devm_kzalloc" instead of "kstrdup".
 2. Updated commit message.

Manish Badarkhe (2):
  devres: introduce API "devm_kstrdup"
  regulator: fixed: update to devm_* API

 drivers/base/devres.c     |   26 ++++++++++++++++++++++++++
 drivers/regulator/fixed.c |   42 ++++++++++++------------------------------
 include/linux/device.h    |    1 +
 3 files changed, 39 insertions(+), 30 deletions(-)

-- 
1.7.10.4

