Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbbAVItp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:49:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41835 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbAVItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:49:36 -0500
Date: Thu, 22 Jan 2015 09:49:41 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>
Cc: linux-acpi@vger.kernel.org, devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] int to bool conversion
Message-ID: <20150122084941.GA14651@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches convert local variables from int to bool when relevant.

The first patch proposes straight forward cases where the conversion
do not suggest changes beyond the function.

The second patch deals with cases where the conversion is propagated
to function parameters.

The third patch is a single case where the variable is given as a
parameter to a kernel macro.

Finally, the fourth patch is a case in which the conversion is
propagated to the field of a structure.


Quentin Lambert (4):
  ACPI: Convert non-returned local variable to boolean when relevant
  ACPI: Convert int variable to bool and propagate to function
    parameters
  ACPI: Convert int to bool for variable later used int kernel macro
  ACPI: Convert int to bool and propagete to struct field

 drivers/acpi/acpi_pad.c         |  6 +++---
 drivers/acpi/acpi_processor.c   |  5 +++--
 drivers/acpi/acpica/acutils.h   |  3 ++-
 drivers/acpi/acpica/utaddress.c |  3 ++-
 drivers/acpi/acpica/utstring.c  | 10 +++++-----
 drivers/acpi/acpica/utxface.c   |  2 +-
 drivers/acpi/dock.c             |  4 ++--
 drivers/acpi/osl.c              |  4 ++--
 drivers/acpi/pci_link.c         |  4 ++--
 drivers/acpi/processor_core.c   | 12 ++++++------
 drivers/acpi/processor_pdc.c    |  5 +++--
 drivers/acpi/scan.c             |  4 ++--
 drivers/acpi/thermal.c          | 10 +++++-----
 13 files changed, 38 insertions(+), 34 deletions(-)

-- 
1.9.1

