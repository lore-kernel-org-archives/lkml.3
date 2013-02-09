Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3BIUMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 15:12:40 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:41149 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932499Ab3BIUMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 15:12:38 -0500
Message-ID: <1360440755.7515.322.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v5 -next 2/2]efi_pstore: Introducing workqueue updating
 sysfs entries
From: Matt Fleming <matt@console-pimps.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Sat, 09 Feb 2013 20:12:35 +0000
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541C8@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541C8@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 00:41 +0000, Seiji Aguchi wrote:
> [Problem]
> efi_pstore creates sysfs entries, which enable users to access to NVRAM,
> in a write callback. If a kernel panic happens in an interrupt context,
> it may fail because it could sleep due to dynamic memory allocations during
> creating sysfs entries.
> 
> [Patch Description]
> This patch removes sysfs operations from a write callback by introducing 
> a workqueue updating sysfs entries which is scheduled after the write
> callback is called.
> 
> Also, the workqueue is kicked in a just oops case.
> A system will go down in other cases such as panic, clean shutdown and emergency 
> restart. And we don't need to create sysfs entries because there is no chance for 
> users to access to them.
> 
> efi_pstore will be robust against a kernel panic in an interrupt context with this patch.
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |   85 +++++++++++++++++++++++++++++++++++++++++---
>  include/linux/efi.h        |    3 +-
>  2 files changed, 82 insertions(+), 6 deletions(-)

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center

