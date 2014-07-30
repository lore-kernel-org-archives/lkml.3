Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaG3WLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:11:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53077 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaG3WLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:11:34 -0400
Date: Thu, 31 Jul 2014 00:11:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mathias Krause <minipli@googlemail.com>
Cc: x86-ml <x86@kernel.org>, linux-crypto@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, crypto: Check if gas supports CRC32
Message-ID: <20140730221127.GF10213@pd.tnic>
References: <20140730164701.GA19604@pd.tnic>
 <20140730211937.GA14864@jig.fritz.box>
 <20140730212814.GA15010@jig.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140730212814.GA15010@jig.fritz.box>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:28:14PM +0200, Mathias Krause wrote:
> Gah, CONFIG_AS_CRC32 gets defined as a preprocessor symbol only so
> cannot be used in makefiles. So crc32c-pcl-intel-asm_64.S needs a
> "#ifdef CONFIG_AS_CRC32" guard and still be compiled for CONFIG_64BIT,
> as it is now. It'll be an empty object for older binutils versions not
> supporting the crc32 instruction.

Yeah, that makes it all even simpler, thanks!

We're still b0rked though:

arch/x86/crypto/crct10dif-pcl-asm_64.S: Assembler messages:
arch/x86/crypto/crct10dif-pcl-asm_64.S:147: Error: no such instruction: `pclmulqdq $0x0,%xmm10,%xmm0'
arch/x86/crypto/crct10dif-pcl-asm_64.S:148: Error: no such instruction: `pclmulqdq $0x11,%xmm10,%xmm8'
arch/x86/crypto/crct10dif-pcl-asm_64.S:149: Error: no such instruction: `pclmulqdq $0x0,%xmm10,%xmm1'
...

and need checking for more instructions. I'll play with this more
tomorrow.

Good night :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
