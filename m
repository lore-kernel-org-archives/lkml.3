Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbbAHPLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:11:40 -0500
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:56488 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbbAHPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:11:38 -0500
Message-ID: <54AE9E27.2050307@nexus-software.ie>
Date: Thu, 08 Jan 2015 15:11:35 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B7326E0CC8@PGSMSX105.gar.corp.intel.com> <54AE8136.2060400@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B7326E297E@PGSMSX105.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B7326E297E@PGSMSX105.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Suggest to split the imr_del() into 2 functions:-
> (1) by address + size
> (2) by IMR index
> At current implementation, it does not support (2) only because it fails at
> imr_check_range().

Hi Boon Leong.

I'll have a think about that :)

Just on imr_del() though, it does support removal by way of index.

+static void __init intel_galileo_imr_init(void)
+{
+	unsigned long base  = virt_to_phys(&_text);
+	unsigned long size = virt_to_phys(&_sinittext) - base - IMR_ALIGN;
+	int i, ret;
+
+	/* Tear down all existing unlocked IMRs */
+	for (i = 0; i <= QUARK_X1000_IMR_NUM; i++)
+		imr_del(i, 0, 0);

That's what the platform code has to do for every unlocked IMR, to make 
sure there are no stale IMRs left that could conflict with the EFI 
memory map !

--
BOD




