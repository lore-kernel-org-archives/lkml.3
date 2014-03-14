Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaCNTg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:36:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:52832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbaCNTg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:36:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,656,1389772800"; 
   d="scan'208";a="500139108"
From: "Moore, Robert" <robert.moore@intel.com>
To: Sabrina Dubroca <sd@queasysnail.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
CC: "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: ACPICA 20140214 auto-serialize weirds my machine...
Thread-Topic: ACPICA 20140214 auto-serialize weirds my machine...
Thread-Index: AQHPP58qJGgIn67g10eWtMCYXVeqCZrhTmWA//+rv9A=
Date: Fri, 14 Mar 2014 19:36:54 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7F9876@ORSMSX103.amr.corp.intel.com>
References: <14866.1394813101@turing-police.cc.vt.edu>
 <20140314173801.GA3755@kria>
In-Reply-To: <20140314173801.GA3755@kria>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EJb9ZJ019087

Sabrina, Valdis:

Do either of you see any error messages like this:

ACPI Error: Mutex [0x1] is not acquired, cannot release (20140214/utmutex-437)



> -----Original Message-----
> From: Sabrina Dubroca [mailto:sd@queasysnail.net]
> Sent: Friday, March 14, 2014 10:38 AM
> To: Valdis Kletnieks
> Cc: Zheng, Lv; Wysocki, Rafael J; Moore, Robert; Len Brown; linux-
> kernel@vger.kernel.org; linux-acpi@vger.kernel.org
> Subject: Re: ACPICA 20140214 auto-serialize weirds my machine...
> 
> Hi,
> 
> 2014-03-14, 12:05:01 -0400, Valdis Kletnieks wrote:
> > Surprisingly enough, this hasn't seemed to have bitten many Linux
> > people yet, Google only finds a BSD thread (where the same ACPICA code
> is in use):
> >
> > http://comments.gmane.org/gmane.os.dragonfly-bsd.user/1817
> 
> I was about to report the same issue on a Dell Latitude D830. Boot
> failure, flood of these messages:
> 
> ACPI Exception: AE_AML_MUTEX_ORDER, while evaluating GPE method [_L1C]
> (20140214/evgpe-580) ACPI Error: Method parse/execution failed [\GPE._L1C]
> (Node f5e0c9a8), AE_AML_MUTEX_ORDER (20140214/psparse-536) ACPI Error:
> Cannot acquire Mutex for method [SX30], current SyncLevel is too large (1)
> (20140214/dsmethod-362) ACPI Exception: AE_AML_MUTEX_ORDER, while
> evaluating GPE method [_L1C] (20140214/evgpe-580)
> 
> With acpi_no_auto_serialize things look good.
> 
> 
> Before I tried that option, a bisection led me to remove "| AML_CREATE"
> from commit f56b05bd111b. That made the laptop boot,
> 
> things seemed okay, except for the battery not being detected: the normal
> battery line was gone ("ACPI: Battery Slot [BAT0] (battery
> present)") and there's this instead:
> 
> ACPI Error: Cannot acquire Mutex for method [SX45], current SyncLevel is
> too large (1) (20140214/dsmethod-362) ACPI Error: Method parse/execution
> failed [\_SB_.BIF_] (Node f5c250d8), AE_AML_MUTEX_ORDER (20140214/psparse-
> 536) ACPI Error: Method parse/execution failed [\_SB_.BAT0._BIF] (Node
> f5c25168), AE_AML_MUTEX_ORDER (20140214/psparse-536) ACPI Exception:
> AE_AML_MUTEX_ORDER, Evaluating _BIF (20140214/battery-416)
> 
> 
> --
> Sabrina
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
