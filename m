Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3EITLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:11:51 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:45465 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3EITLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:11:49 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] aerdrv: Move cper_print_pcie() out of interrupt context
Thread-Topic: [PATCH] aerdrv: Move cper_print_pcie() out of interrupt context
Thread-Index: AQHOTDeSaY5w5FoPvkaxQxiCMhoJDJj9NrcQ
Date: Thu, 9 May 2013 19:10:36 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F95177AFA9@G4W3219.americas.hpqcorp.net>
References: <20130508171519.26724.63307.stgit@grignak.americas.hpqcorp.net>
 <2598827.AVAqMcfGuF@vostro.rjw.lan>
In-Reply-To: <2598827.AVAqMcfGuF@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.31]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r49JBtkD016646

Rafael,  

Thanks for your feedback.

> The way the changes are described here isn't particularly clear to me.

I will try to make it a little more clear.


> Also, since aer_recover_work_func() is going to be the only existing
> caller of
> cper_print_aer() after this change, as far as I can say, and it doesn't
> use the
> function's first argument, that argument should be dropped entirely.

The truth is, the function cper_print_aer() really needs to be re-written so it is consistent with aer_print_error() in how it outputs information.  Right now, the output is formatted very differently.  I was planning on doing that at a later date, but fix the warning now.  I might add a TODO comment in the code for this.

The reason I did not remove the argument in cper_print_aer() is because 'prefix' is used in the call to cper_print_bits(), and I passed through an empty string to make sure that function worked correctly.  I can try to clean it up.

Lance
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
