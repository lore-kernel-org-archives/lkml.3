Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967409Ab3E3E5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 00:57:14 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48984 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3E3E5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 00:57:09 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
Thread-Topic: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
Thread-Index: AQHOXL6xaJHLIdYYMUCf//A2tjAxCpkcyS2AgABcuTA=
Date: Thu, 30 May 2013 04:55:20 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F95D13A6F2@G9W0715.americas.hpqcorp.net>
References: <20130529190326.24171.86905.stgit@grignak.americas.hpqcorp.net>
 <30463843.EmBn1xaq3I@vostro.rjw.lan>
 <3908561D78D1C84285E8C5FCA982C28F2DA70112@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA70112@ORSMSX106.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.17]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4U4vKg8014799

> > +	/*
> > +	 * TODO: This function needs to be re-written so that it's output
> > +	 * matches the output of aer_print_error().  Right now, the
> output
> > +	 * is formatted very differently.
> > +	 */
> 
> So we have this big "TODO" comment sitting there very prominently ...
> which Linus
> is bound to ask about if I ask him to pull this into 3.10-rcX ...
> what's the impact of
> this?  What should I say when he asks why should he pull this fix into
> 3.10 when
> there is still some work to do?  Is matching the output no big deal and
> can wait for
> some future, while moving the pci bits to the work function needs to go
> in now?

Tony, 

You have a good point.  Ideally the console output should be the same in both the aer and the cper case.  The output in cper_print_error() does give us a reasonable amount of information, just not as detailed as I the aer case. Also now what we have the trace event for aer, the console output might be less important.  This TODO is a note for future clean-up and is not directly related to the bug being fixed with this patch.  Which lends to the argument of why put the TODO in this patch?  Opportunistic.  I donâ€™t think we want to create a separate patch just for a TODO note.  

So, why pull this patch in even though there is work to do?  The patch fixes a warning that might cause customers un-due concern and removes a call in interrupt context that should not be there.  

Lance
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
