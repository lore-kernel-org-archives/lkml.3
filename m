Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab3GPLzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:55:35 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:34907 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932328Ab3GPLzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:55:33 -0400
Date: Tue, 16 Jul 2013 21:55:27 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
Message-ID: <20130716115527.GA1034@gondor.apana.org.au>
References: <201307162053.GBC56724.MFVOJtSLQHFOOF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307162053.GBC56724.MFVOJtSLQHFOOF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 08:53:02PM +0900, Tetsuo Handa wrote:
> I got below failure.
> 
>   [    5.258911] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
>   [    5.267651] modprobe (156) used greatest stack depth: 4064 bytes left
>   [    5.293607] Fusion MPT base driver 3.04.20
>   [    5.294416] Copyright (c) 1999-2008 LSI Corporation
>   [    5.300109] Fusion MPT SPI Host driver 3.04.20
>   [    5.300967] Switched to clocksource tsc
>   [    5.310921] mptbase: ioc0: Initiating bringup
>   [    5.329480] ioc0: LSI53C1030 B0: Capabilities={Initiator}
>   [    5.373136] scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
>   [    5.406190] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
>   [    5.408582] scsi target2:0:0: Beginning Domain Validation
>   [    5.415451] scsi target2:0:0: Domain Validation skipping write tests
>   [    5.416399] scsi target2:0:0: Ending Domain Validation
>   [    5.417445] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
>   [    5.419855] scsi 2:0:1:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
>   [    5.420404] scsi target2:0:1: Beginning Domain Validation
>   [    5.423171] scsi target2:0:1: Domain Validation skipping write tests
>   [    5.423363] scsi target2:0:1: Ending Domain Validation
>   [    5.424440] scsi target2:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
>   [    5.439700] modprobe (211) used greatest stack depth: 3872 bytes left
>   [    5.561700] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cdda tray
>   [    5.562596] cdrom: Uniform CD-ROM driver Revision: 3.20
>   [    5.667330] scsi_id (264) used greatest stack depth: 3568 bytes left
>   FATAL: Module scsi_wait_scan not found.
>   
>   FATAL: Module scsi_wait_scan not found.
>   
>   FATAL: Module scsi_wait_scan not found.
>   (...snipped...)
>   [   60.308916] dracut Warning: Boot has failed. To debug this issue add "rdshell" to the kernel command line.
>   [   60.311431] dracut Warning: Signal caught!
> 
> Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-3.11-rc1
> 
> Bisected to commit 2d31e518 "crypto: crct10dif - Wrap crc_t10dif function all
> to use crypto transform framework", and confirmed that changing from
> CONFIG_CRYPTO_CRCT10DIF=m to CONFIG_CRYPTO_CRCT10DIF=y solves this problem.

Looks like a bug in whatever is creating the initrd as it isn't
including modules necessary for the boot.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
