Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3JGPV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:21:27 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38037 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab3JGPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:20:47 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
        Ashok Kumar <ashoks@broadcom.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: linux-next: build failure after merge of the mips tree
Date: Mon,  7 Oct 2013 17:18:44 +0200
Message-Id: <1381159127-11067-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381159127-11067-1-git-send-email-treding@nvidia.com>
References: <1381159127-11067-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge fails to build on various default configuration
builds. This seems to be caused by the following commit:

	5395d97 MIPS: Fix start of free memory when using initrd

Looking at the patchwork URLs in that commit message, Greg's original
patch seems to have been fine, but Ashok's patch uses the initrd_end
symbol outside of the section protected by an CONFIG_BLK_DEV_INITRD
#ifdef and therefore causes to fail during linking.

I've reverted the patch in today's linux-next tree.

Thierry
