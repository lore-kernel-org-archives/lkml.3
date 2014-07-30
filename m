Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaG3V2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:28:25 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:44544 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaG3V2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:28:23 -0400
Date: Wed, 30 Jul 2014 23:28:14 +0200
From: Mathias Krause <minipli@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, linux-crypto@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, crypto: Check if gas supports CRC32
Message-ID: <20140730212814.GA15010@jig.fritz.box>
References: <20140730164701.GA19604@pd.tnic>
 <20140730211937.GA14864@jig.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730211937.GA14864@jig.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:19:37PM +0200, Mathias Krause wrote:
> On Wed, Jul 30, 2014 at 06:47:01PM +0200, Borislav Petkov wrote:
> > [...]
> 
> This looks too complicated. We do have as-instr for exactly those kind
> of tests. And, in fact, looking at arch/x86/Makefile we already have one
> for crc32:
> 
>   asinstr += $(call as-instr,crc32l %eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
> 
> So you can just used CONFIG_AS_CRC32 for your tests and drop the shell
> script.
> 
> > +ifdef CONFIG_64BIT
> > +crc32c-intel-$(CONFIG_GAS_SUPPORTS_CRC32) += crc32c-pcl-intel-asm_64.o
> > +endif
> 
> s/CONFIG_GAS_SUPPORTS_CRC32/CONFIG_AS_CRC32/ here and for all further
> uses.
> 

Gah, CONFIG_AS_CRC32 gets defined as a preprocessor symbol only so
cannot be used in makefiles. So crc32c-pcl-intel-asm_64.S needs a
"#ifdef CONFIG_AS_CRC32" guard and still be compiled for CONFIG_64BIT,
as it is now. It'll be an empty object for older binutils versions not
supporting the crc32 instruction.

Sorry for the confusion.


Regards,
Mathias
