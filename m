Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3DZJz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:55:59 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56692 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab3DZJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:55:57 -0400
Message-ID: <517A4F2A.4080906@intel.com>
Date: Fri, 26 Apr 2013 10:55:54 +0100
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
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org> <A5ED84D3BB3A384992CBB9C77DEDA4D41AFCC9D0@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFCC9D0@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/13 00:55, Seiji Aguchi wrote:
> Hi,
> 
> I tested a current tip tree to check if the new API works.
> But pstore_erase() doesn't work...
> I'm checking the source code right now.
> 
> Seiji

[...]

> Call Trace:
>  [<ffffffff8143001f>] efi_pstore_erase+0xdf/0x130
>  [<ffffffff81200038>] ? cap_socket_create+0x8/0x10
>  [<ffffffff811ea491>] pstore_unlink+0x41/0x60
>  [<ffffffff811741ff>] vfs_unlink+0x9f/0x110
>  [<ffffffff8117813b>] do_unlinkat+0x18b/0x280
>  [<ffffffff81178472>] sys_unlinkat+0x22/0x40
>  [<ffffffff81542402>] system_call_fastpath+0x16/0x1b

Does this patch fix things?

---

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 47ae712..b820593 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -173,7 +173,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 			    struct timespec time, struct pstore_info *psi)
 {
 	struct pstore_erase_data edata;
-	struct efivar_entry *entry;
+	struct efivar_entry *entry = NULL;
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	int found, i;
