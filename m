Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaCXHuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 03:50:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:52537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaCXHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 03:50:15 -0400
Message-ID: <532FE3B2.9060808@biereigel-wb.de>
Date: Mon, 24 Mar 2014 08:50:10 +0100
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Stefan Biereigel <stefan@biereigel.de>, lenb@kernel.org, rjw@rjwysocki.net
Subject: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after suspend
 to RAM.
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:pWoaDIMxg18WaQYAEOUfC6D2ckZJS1w63R+SaLNgAsM
 QQPxYWFko5b+oCJhAYIYTFo6LloFMMNaLDh7Wcea3hFhQLjbKy
 vyheIcigo32dYRXupBJ3mYrzgMOsI4ErLawK1l0hFD8MiSo6zj
 OQlTkxxXwlYBlDiFABG9G4fMdZaf4vjVjclq/bIaYMm9jDgB50
 th8m5BhLqIUTa2rPgWLw12lYTxNLpac0gAMBtN9Jp4FhMPUgq4
 QnPz2QW+1QRIvZxFKJ1ZgeDhHnvgJLQcngimXRSwz90Jvo637n
 d7u5RCyYNXH74QpXll9HI5mXHm2SCo1BapohQJTV/Efgl+5Uxs
 BIh/IEmfTX36KBjrn+3fo4SoNYH1pkJTRwVR549Zr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

starting with 3.14-rc6, the lid on my Samsung N150 behaves weird: My
system is set up, so that it should suspend to RAM as soon as the lid is
closed. Beginning with 3.14-rc6, the lid goes from "open" to "closed"
correctly the first time (and the system suspends), but after resuming
from standby (by opening the lid), the lid does not change to "open" again.
Of course, closing the lid again does not induce suspend to RAM then.
Opening the lid now (while not sleeping), makes ACPI notify the opening,
so I guess ACPI "misses" or discards the lid open event from the EC when
coming from sleep.
Now, closing the lid again does induce suspend to RAM. This behaviour is
reproducible: every other time, suspending works.

This behaviour seems to be introduced by commit ad332c8a: ACPI / EC:
Clear stale EC events on Samsung systems.
Which was introduced after 3.14-rc5.

When opening the lid to resume from standby, i see in dmesg:
Mar 23 22:12:04 little1 kernel: [ 7630.932074] ACPI : EC: 1 stale EC
events cleared
(which comes from drivers/acpi/ec.c)

Seems to me, that the "open" event is cleared from the EC, but also
discarded instead of passed on. Shouldn't the correct behaviour be to
report all the pending events, read from the EC, as ACPI events? Can you
point me in a direction for fixing the issue cleanly, then I will try to
find a solution and prepare a patch for this issue.

Best regards,
Stefan

