Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaBYUa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:30:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59678 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbaBYUaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:30:55 -0500
Message-ID: <530CFD6C.7040705@zytor.com>
Date: Tue, 25 Feb 2014 12:30:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andrey Panin <pazke@donpac.ru>,
        David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: RFC: Removing Visual Workstation and NUMAQ
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to remove Visual Workstation and NUMAQ from the x86 kernel.
 This removes a fair bit of code which from the current looks is only
being made to suffer general patches:

Visual Workstation:

 Documentation/sgi-visws.txt            |  13 -
 MAINTAINERS                            |   7 -
 arch/x86/Kconfig                       |  13 -
 arch/x86/include/asm/visws/cobalt.h    | 127 -----
 arch/x86/include/asm/visws/lithium.h   |  53 --
 arch/x86/include/asm/visws/piix4.h     | 107 ----
 arch/x86/include/asm/visws/sgivw.h     |   5 -
 arch/x86/pci/Makefile                  |   2 -
 arch/x86/pci/visws.c                   |  87 ----
 arch/x86/platform/Makefile             |   1 -
 arch/x86/platform/visws/Makefile       |   1 -
 arch/x86/platform/visws/visws_quirks.c | 608 -----------------------
 12 files changed, 1024 deletions(-)

NUMAQ:

 arch/x86/include/asm/numaq.h    | 171 ----------
 arch/x86/kernel/apic/Makefile   |   1 -
 arch/x86/kernel/apic/numaq_32.c | 524 ------------------------------
 arch/x86/pci/Makefile           |   1 -
 arch/x86/pci/numaq_32.c         | 165 ----------
 5 files changed, 862 deletions(-)


If there still are people who care about these platforms, please speak up.

	-hpa
