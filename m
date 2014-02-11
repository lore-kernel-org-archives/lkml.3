Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaBKNRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:17:04 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48247 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbaBKNRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:17:01 -0500
Date: Tue, 11 Feb 2014 13:16:40 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Message-ID: <20140211131640.GD2887@console-pimps.org>
References: <8738jr5t3e.fsf@redhat.com>
 <20140210175246.GB2887@console-pimps.org>
 <87mwhy8iaj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwhy8iaj.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb, at 11:00:52AM, Madper Xie wrote:
> it doesn't help, seems the same panic output:

OK, thanks for testing so quickly.

> [    0.001341] BUG: unable to handle kernel paging request at ffffffffff340003
> [    0.008339] IP: [<ffffffff81a73794>] efi_bgrt_init+0x9d/0x133
> [    0.014111] PGD 28fb067 PUD 28fd067 PMD 2bef067 PTE 9376e01800000163

Thinking about this a bit harder that PTE is invalid because bits 52-63
are not zero, which is exactly the problem you were hitting prior to
-rc2, namely that the physical BGRT address is bogus.

Can you post the EFI memory map entries from a dmesg? I just want to
make sure that it really is the BGRT address that is broken and not
something else. Also, please post the ACPI: BGRT entry from your dmesg
too. Thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
