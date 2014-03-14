Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaCNRiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:38:20 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:47894 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbaCNRiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:38:19 -0400
Date: Fri, 14 Mar 2014 18:38:01 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: ACPICA 20140214 auto-serialize weirds my machine...
Message-ID: <20140314173801.GA3755@kria>
References: <14866.1394813101@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14866.1394813101@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-14, 12:05:01 -0400, Valdis Kletnieks wrote:
> Surprisingly enough, this hasn't seemed to have bitten many Linux people yet,
> Google only finds a BSD thread (where the same ACPICA code is in use):
> 
> http://comments.gmane.org/gmane.os.dragonfly-bsd.user/1817

I was about to report the same issue on a Dell Latitude D830. Boot
failure, flood of these messages:

ACPI Exception: AE_AML_MUTEX_ORDER, while evaluating GPE method [_L1C] (20140214/evgpe-580)
ACPI Error: Method parse/execution failed [\GPE._L1C] (Node f5e0c9a8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
ACPI Error: Cannot acquire Mutex for method [SX30], current SyncLevel is too large (1) (20140214/dsmethod-362)
ACPI Exception: AE_AML_MUTEX_ORDER, while evaluating GPE method [_L1C] (20140214/evgpe-580)

With acpi_no_auto_serialize things look good.


Before I tried that option, a bisection led me to remove
"| AML_CREATE" from commit f56b05bd111b. That made the laptop boot,

things seemed okay, except for the battery not being detected: the
normal battery line was gone ("ACPI: Battery Slot [BAT0] (battery
present)") and there's this instead:

ACPI Error: Cannot acquire Mutex for method [SX45], current SyncLevel is too large (1) (20140214/dsmethod-362)
ACPI Error: Method parse/execution failed [\_SB_.BIF_] (Node f5c250d8), AE_AML_MUTEX_ORDER (20140214/psparse-536)
ACPI Error: Method parse/execution failed [\_SB_.BAT0._BIF] (Node f5c25168), AE_AML_MUTEX_ORDER (20140214/psparse-536)
ACPI Exception: AE_AML_MUTEX_ORDER, Evaluating _BIF (20140214/battery-416)


-- 
Sabrina
