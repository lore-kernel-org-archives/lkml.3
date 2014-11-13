Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaKMTSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:18:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:35357 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaKMTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:18:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,379,1413270000"; 
   d="scan'208";a="607429849"
From: "Luck, Tony" <tony.luck@intel.com>
To: "yath@yath.de" <yath@yath.de>
CC: "keescook@chromium.org" <keescook@chromium.org>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Subject: RE: randconfig build error with next-20141113, in fs/pstore/inode.c
Thread-Topic: randconfig build error with next-20141113, in fs/pstore/inode.c
Thread-Index: AQHP/1GgomXQZGroHUqfW2GR/zL7mJxe6vmg
Date: Thu, 13 Nov 2014 19:18:11 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292CD43@ORSMSX114.amr.corp.intel.com>
References: <CA+r1ZhjO=kxcyjRb3=d7ozZ_VT9a+iCUy27zPZ2WGVMMzP6OVA@mail.gmail.com>
In-Reply-To: <CA+r1ZhjO=kxcyjRb3=d7ozZ_VT9a+iCUy27zPZ2WGVMMzP6OVA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sADJIvrX026508

> Building with the attached random configuration file,
>
> fs/built-in.o: In function `pstore_check_syslog_permissions':
> inode.c:(.text+0x13a1bd): undefined reference to `check_syslog_permissions'
> make: *** [vmlinux] Error 1

Sebastian,

This looks to come from your "Honor dmesg_restrict sysctl on dmesg dumps" patch

The randconfig doesn't have CONFIG_PRINTK.  I guess we need to provide a stub
in <linux/syslog.h> to cover this.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
