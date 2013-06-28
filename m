Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3F1UOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3F1UOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:14:16 -0400
From: Lenny Szubowicz <lszubowi@redhat.com>
To: tony.luck@intel.com, cbouatmailru@gmail.com, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org
Cc: n.hamaguchi@jp.fujitsu.com, dzickus@redhat.com
Subject: [PATCH 0/3] acpi: Eliminate misleading erst pstore console message 
Date: Fri, 28 Jun 2013 16:14:08 -0400
Message-Id: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems that have a valid ACPI ERST table, if the pstore.backend kernel
parameter selects a specific facility other than erst, then during boot the
following console message is displayed:

    ERST: Could not register with persistent store

This message makes it seem that something has gone wrong. In fact the same
message is used when you want ERST to be used by pstore and some real error
precludes registration.

The primary purpose of this 3 patch set is to avoid displaying this console
error message when another facility is explicitly selected as the backend for
pstore. Details are in the individual patches.


Lenny Szubowicz (3):
  pstore: Return unique error if backend registration excluded by kernel
    param
  acpi: Eliminate console msg if pstore.backend excludes ERST
  efivars: If pstore_register fails, free unneeded pstore buffer

 drivers/acpi/apei/erst.c          | 20 ++++++++++++++------
 drivers/firmware/efi/efi-pstore.c |  6 +++++-
 fs/pstore/platform.c              | 11 ++++++-----
 3 files changed, 25 insertions(+), 12 deletions(-)

-- 
1.8.2.1

