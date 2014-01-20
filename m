Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaATNq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:46:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:7231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaATNq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:46:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,690,1384329600"; 
   d="scan'208";a="441668202"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: "JBottomley@Parallels.com" <JBottomley@Parallels.com>
CC: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Patelczyk, Maciej" <maciej.patelczyk@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] isci: reformulate for_each_isci_host macro to fix an
 oops
Thread-Topic: [PATCH] isci: reformulate for_each_isci_host macro to fix an
 oops
Thread-Index: AQHPEr1WkBaf4d0XqEaBF9e1y+D1ipqNpWfw
Date: Mon, 20 Jan 2014 13:46:11 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6A4055@IRSMSX105.ger.corp.intel.com>
References: <20140116131624.24112.8745.stgit@gklab-154-244.igk.intel.com>
In-Reply-To: <20140116131624.24112.8745.stgit@gklab-154-244.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0KDl6T4004035

On Thursday, January 16, 2014 2:16 PM Lukasz Dorau <lukasz.dorau@intel.com> wrote:
> 
> The loop 'for' in macro 'for_each_isci_host' (drivers/scsi/isci/init.c:717)
> is executed more times than it can be. Regardless the condition:
>    'id < ARRAY_SIZE(to_pci_info(pdev)->hosts)' (drivers/scsi/isci/host.h:315)
> it is executed when id equals ARRAY_SIZE(to_pci_info(pdev)->hosts) too.
> (Remark: ARRAY_SIZE(to_pci_info(pdev)->hosts) always equals
> SCI_MAX_CONTROLLERS = 2)
> 
> It sounds crazy, but it is truth. I have checked it in the following way:
> I have added the line:
> 
>    printk(KERN_ERR ">>> (%d < %d) == %d \n", \
>           i, SCI_MAX_CONTROLLERS, (i < SCI_MAX_CONTROLLERS));
> 
> after the 'for_each_isci_host' macro in drivers/scsi/isci/init.c:701
> and received the following output:
> 
>    >>> (0 < 2) == 1
>    >>> (1 < 2) == 1
>    >>> (2 < 2) == 1
> 
> after issuing 'modprobe isci' command on platform with two SCU controllers
> (Patsburg D or T chipset required).
> The kernel was compiled using gcc version 4.8.2.
> 

Hi James,

Please disregard this patch.
It turned to be a GCC 4.8 bug:
http://marc.info/?l=linux-kernel&m=138998871911336&w=2

I will write a new patch.

Lukasz

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
