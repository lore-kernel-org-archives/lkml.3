Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaDOMSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:18:38 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:51357 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbaDOMSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:18:36 -0400
Message-ID: <1397564314.2056.10.camel@x41>
Subject: Re: Build regressions/improvements in v3.15-rc1
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 14:18:34 +0200
In-Reply-To: <1397561816-9289-1-git-send-email-geert@linux-m68k.org>
References: <1397561816-9289-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 12:18:34.0628 (UTC) FILETIME=[D27C5C40:01CF58A4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven schreef op di 15-04-2014 om 13:36 [+0200]:
>   + /scratch/kisskb/src/arch/x86/crypto/sha1_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 50:1
>   + /scratch/kisskb/src/arch/x86/crypto/sha256_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 56:1
>   + /scratch/kisskb/src/arch/x86/crypto/sha512_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 55:1
>   + /scratch/kisskb/src/arch/x86/kernel/machine_kexec_32.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 191:12
>   + /scratch/kisskb/src/arch/x86/kernel/syscall_32.c: warning: 'externally_visible' attribute ignored [-Wattributes]:  => 14:1

Probably all fixed with " [PATCH 1/3] Revert "lto: Make asmlinkage
__visible", see https://lkml.org/lkml/2014/4/1/757. (At least, similar
warnings were gone here with that patch applied.) Not sure were that
patch is queued.

>   + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]:  => 405:4

Fixed by "[PATCH] Revert "drm/i915: fix build warning on 32-bit (v2)"",
see https://lkml.org/lkml/2014/4/7/119 . Is that one queued somewhere?

>   + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'trans_support' may be used uninitialized in this function [-Wuninitialized]:  => 7467:20

First reported (for linux-next it seems) in
https://lkml.org/lkml/2014/3/26/30 . Fix is currently discussed in the
(short) thread starting at https://lkml.org/lkml/2014/4/10/633 .


Paul Bolle

