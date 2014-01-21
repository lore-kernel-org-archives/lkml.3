Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaAUS0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:26:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46334 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbaAUS0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:26:09 -0500
Date: Tue, 21 Jan 2014 19:25:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140121182554.GE9004@pd.tnic>
References: <52DE94A9.9060505@oracle.com>
 <20140121161438.GD9004@pd.tnic>
 <52DEB4A9.4070707@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52DEB4A9.4070707@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:55:53PM -0500, Boris Ostrovsky wrote:
>         cat $(AMD_UCODE_PATH)/* >
> ucode_initrd/kernel/x86/microcode/AuthenticAMD.bin
>         (cd ucode_initrd;find . | cpio -o -H newc >
> ../$(DISTDIR)/common/ucode_initrd.cpio)
>         ...
>         cat $(DISTDIR)/common/ucode_initrd.cpio \
>             $(DISTDIR)/common/_initramfs.cpio.gz > \
>             $(DISTDIR)/common/initramfs.cpio.gz
> 
> and as I just discovered, with a little twist: apparently
> AMD_UCODE_PATH points to Intel microcode.

LOL!

@hpa: in case you were wondering whether Intel ucode works on AMD - it
doesn't! :-)

> So we clearly screwed up on our end but I'd think that we shouldn't
> crash when this happens.

Yes, we shouldn't. I'll try to reproduce it here.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
