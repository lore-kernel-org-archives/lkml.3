Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3DZOzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:55:13 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54593 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3DZOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:55:11 -0400
Message-ID: <517A954C.7060505@intel.com>
Date: Fri, 26 Apr 2013 15:55:08 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi2] efivars: efivar_entry API
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org> <A5ED84D3BB3A384992CBB9C77DEDA4D41AFCC9D0@USINDEM103.corp.hds.com> <517A4F2A.4080906@intel.com> <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E2B@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E2B@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 15:25, Seiji Aguchi wrote:
> Matt,
> 
> Thanks.
> With your patch, It works in case each entry is erased one by one as below.
> # rm dmesg-efi-1
> #rm dmesg-efi-2 

How about if you add this to efi_pstore_erase_func()?

---

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index b820593..393d63a 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -166,6 +166,7 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 
 	/* found */
 	__efivar_entry_delete(entry);
+	list_del(&entry->list);
 	return 1;
 }
 
