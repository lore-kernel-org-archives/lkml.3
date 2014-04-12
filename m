Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaDLN3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 09:29:51 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:55337 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaDLN3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 09:29:49 -0400
MIME-Version: 1.0
In-Reply-To: <5348ea4572e7_5d4d7ac86c27677@209.249.196.67.mail>
References: <5348ea4572e7_5d4d7ac86c27677@209.249.196.67.mail>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 12 Apr 2014 07:29:29 -0600
Message-ID: <CAErSpo6r3Xw8fZ7eaW=8Mg9EabtPUAOQU8ExGt4aYL--+OnLgA@mail.gmail.com>
Subject: Fwd: New Defects reported by Coverity Scan for Linux
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, looks like these were added by a4dff76924fe ("x86/gpu: Add Intel
graphics stolen memory quirk for gen2 platforms").


---------- Forwarded message ----------
From:  <scan-admin@coverity.com>
Date: Sat, Apr 12, 2014 at 1:24 AM
Subject: New Defects reported by Coverity Scan for Linux
To:

...

** CID 1201423:  Unintended sign extension  (SIGN_EXTENSION)
/arch/x86/kernel/early-quirks.c: 290 in i830_mem_size()

** CID 1201424:  Unintended sign extension  (SIGN_EXTENSION)
/arch/x86/kernel/early-quirks.c: 295 in i85x_mem_size()

...
________________________________________________________________________________________________________
*** CID 1201423:  Unintended sign extension  (SIGN_EXTENSION)
/arch/x86/kernel/early-quirks.c: 290 in i830_mem_size()
284
285             return MB(1);
286     }
287
288     static size_t __init i830_mem_size(void)
289     {
>>>     CID 1201423:  Unintended sign extension  (SIGN_EXTENSION)
>>>     Suspicious implicit sign extension: "read_pci_config_byte(0, 0, 0, 99)" with type "unsigned char" (8 bits, unsigned) is promoted in "read_pci_config_byte(0, 0, 0, 99) * 33554432" to type "int" (32 bits, signed), then sign-extended to type "unsigned long" (64 bits, unsigned).  If "read_pci_config_byte(0, 0, 0, 99) * 33554432" is greater than 0x7FFFFFFF, the upper bits of the result will all be 1.
290             return read_pci_config_byte(0, 0, 0, I830_DRB3) * MB(32);
291     }
292
293     static size_t __init i85x_mem_size(void)
294     {
295             return read_pci_config_byte(0, 0, 1, I85X_DRB3) * MB(32);

________________________________________________________________________________________________________
*** CID 1201424:  Unintended sign extension  (SIGN_EXTENSION)
/arch/x86/kernel/early-quirks.c: 295 in i85x_mem_size()
289     {
290             return read_pci_config_byte(0, 0, 0, I830_DRB3) * MB(32);
291     }
292
293     static size_t __init i85x_mem_size(void)
294     {
>>>     CID 1201424:  Unintended sign extension  (SIGN_EXTENSION)
>>>     Suspicious implicit sign extension: "read_pci_config_byte(0, 0, 1, 67)" with type "unsigned char" (8 bits, unsigned) is promoted in "read_pci_config_byte(0, 0, 1, 67) * 33554432" to type "int" (32 bits, signed), then sign-extended to type "unsigned long" (64 bits, unsigned).  If "read_pci_config_byte(0, 0, 1, 67) * 33554432" is greater than 0x7FFFFFFF, the upper bits of the result will all be 1.
295             return read_pci_config_byte(0, 0, 1, I85X_DRB3) * MB(32);
296     }
297
298     /*
299      * On 830/845/85x the stolen memory base isn't available in any
300      * register. We need to calculate it as TOM-TSEG_SIZE-stolen_size.
