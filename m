Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaEUXUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:20:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:45628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaEUXT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:19:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,883,1392192000"; 
   d="scan'208";a="515699778"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Andi Kleen" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: RE: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Topic: [RFC] x86_64: A real proposal for iret-less return to kernel
Thread-Index: AQHPdT5wRvlmui20OUO5csd5VXpJ+ZtMCOaA//+MFSCAAHmbAP//i7GAgAB3ZAD//4s2oAAPHlmAAABRNgAADkH6oP//k0EAgABy/7A=
Date: Wed, 21 May 2014 23:19:57 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32811C5F@ORSMSX114.amr.corp.intel.com>
References: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic>
 <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
 <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
 <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
 <20140521224816.GP25130@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
 <CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
In-Reply-To: <CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4LNK9at022984

> FWIW, this means that there really is a problem if one of these #MC
> errors hits an innocent bystander who just happens to be handling an
> NMI, at least if we delete the nested NMI code.  But I think my
> simplified proposal gets this right.

Yes. Bystander broadcast machine checks can and will hit processors
that are in NMI context ... and we must not make that fatal. Peek
harder at your proposal so you can state confidently that you get
this right.  "I think ... gets this right" is a bit too wishy-washy for
mission critical :-)

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
