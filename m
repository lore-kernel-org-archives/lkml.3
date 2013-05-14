Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3ENRJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:09:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11071 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3ENRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:09:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,671,1363132800"; 
   d="scan'208";a="23983051"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-acpi@vger.kernel.org>, <xen-devel@lists.xensource.com>
CC: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH 0/2] Implement ACPI S3 for Xen dom0
Date: Tue, 14 May 2013 13:09:15 -0400
Message-ID: <1368551357-3903-1-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series provides a mechanism for a Xen based dom0 to
be able to suspend the platform to ACPI S3.

The first patch provides a registration mechanism for alternate
implementations of acpi_suspend_lowlevel.

The second patch provides a Xen specific version of this, and hooks
into the callback.

Regards,
Ben Guthro

Konrad Rzeszutek Wilk (2):
  x86/acpi/sleep: Provide registration for acpi_suspend_lowlevel.
  xen/acpi/sleep: Register to the acpi_suspend_lowlevel a callback.

 arch/x86/include/asm/acpi.h  |    2 +-
 arch/x86/kernel/acpi/boot.c  |    7 +++++++
 arch/x86/kernel/acpi/sleep.c |    4 ++--
 arch/x86/kernel/acpi/sleep.h |    2 ++
 drivers/acpi/sleep.c         |    2 ++
 include/xen/acpi.h           |   16 +++++++++++++++-
 6 files changed, 29 insertions(+), 4 deletions(-)

-- 
1.7.9.5

