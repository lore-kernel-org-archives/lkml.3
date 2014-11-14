Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161757AbaKNThU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:37:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:48034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965580AbaKNThR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:37:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,387,1413270000"; 
   d="scan'208";a="608046259"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Andi Kleen" <andi@firstfloor.org>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/s7+MsolZCiViEiCPzqCVeTRAJxdoOwAgACR1oD//3yvMIAAtdCAgAB2NOCAAM3pAP//e6+AgACK+ACAAAdiAIAAGwAAgACUXsCAAJ8cAP//gGJw
Date: Fri, 14 Nov 2014 19:37:15 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3293BB97@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com>
 <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
 <CALCETrVx7hGZodWfAoU1oee1SW7XXSn3Lr8Vs9JTOUMNtLXY4A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292D57B@ORSMSX114.amr.corp.intel.com>
 <CALCETrVB9VQPqFb7GQyxmVEKYtPhppmZS8SewQmtre+3_su9FA@mail.gmail.com>
 <CALCETrVJE25Txr5vRKAxHpeKx9p0VJBbat44w+X4gT8qX7a4bg@mail.gmail.com>
 <CALCETrVYWAOzaHqet8gS5hafvQC9prrH05qgc+v5dxSL9AF8bg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293A5D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrVHS2YM+bWeoSpZgk3Q8P3rVVHmG5o9T55f+EkTj6He4A@mail.gmail.com>
In-Reply-To: <CALCETrVHS2YM+bWeoSpZgk3Q8P3rVVHmG5o9T55f+EkTj6He4A@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAEJbRvn003247

> So far, the only thing I've come up with is that do_machine_check
> seems to be missing exception_enter or the equivalent.  Do you have
> CONFIG_CONTEXT_TRACKING on and/or full nohz enabled?  I don't think
> that this explains my bug, though.

Yes to both:

$ grep CONTEXT_TRACK .config
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_HAVE_CONTEXT_TRACKING=y

$ grep HZ .config
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_MACHZ_WDT=m

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
