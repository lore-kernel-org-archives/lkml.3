Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaDGIBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:01:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:15088 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaDGIBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:01:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,808,1389772800"; 
   d="scan'208";a="516033418"
Message-ID: <53425B2A.10001@linux.intel.com>
Date: Mon, 07 Apr 2014 16:00:42 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
References: <20140404064120.GB11877@gmail.com>	<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>	<20140404080006.GB6944@gmail.com>	<533EB5F1.8060002@linux.intel.com>	<20140404151359.GB12370@srcf.ucam.org> <20140406184023.1e31412d@alan.etchedpixels.co.uk> <53419F84.2090204@zytor.com>
In-Reply-To: <53419F84.2090204@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/7 2:40, H. Peter Anvin wrote:
> 
> No question. The question at hand is if we should do it after all other
> non-terminal (BIOS, triple) methods have been tried.
> 

The reboot sequence before the change is:
(1) ACPI
(2) KEYBOARD
(3) ACPI
(4) KEYBOARD
(5) TRIPLE

The reboot sequence after the change is:
(1) ACPI
(2) KEYBOARD
(3) ACPI
(4) KEYBOARD
(ADD_1) EFI
(ADD_2) CF9
(ADD_3) BIOS
(5) TRIPLE

Steven's machine exactly hit (5), while CF9 hangs, so we encountered
this regression.

EFI is no question. So, Is everybody okay with the following sequence?
(1) ACPI
(2) KEYBOARD
(3) ACPI
(4) KEYBOARD
(ADD_1) EFI
(5) TRIPLE
(ADD_2) CF9
(ADD_3) BIOS

Thanks,
-Aubrey
