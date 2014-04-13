Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaDMDN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 23:13:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45490 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaDMDN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 23:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <87lhvahr7z.fsf@tassilo.jf.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<CAMzpN2jn69_E7UEP6OHBbc4r7UuJbsW50WA25YhXuQs5sHFxQQ@mail.gmail.com>
	<6f5f98f2-aa96-433f-9ee8-5ba216624957@email.android.com>
	<20140412193541.GA30697@pd.tnic>
	<21a22ace-fbc3-4f97-a277-9cdf4f2253eb@email.android.com>
	<CA+55aFy8s7cfaAXJ7WyJ4aMpBnsWGt2mA1=pduQwK+ofkvbzVg@mail.gmail.com>
	<5349BD3F.6000402@zytor.com>
	<87lhvahr7z.fsf@tassilo.jf.intel.com>
Date: Sat, 12 Apr 2014 20:13:25 -0700
X-Google-Sender-Auth: tMiBGXjprhjYgKwBOpo5BAOCMpI
Message-ID: <CA+55aFy=do-mxp4Ufg_vNKfp0CuZmDUGHQzV059TAN8bXbiCAQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 7:56 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Why? Either it works or it doesn't.
>
> If it works it doesn't make any sense to have a sysctl.

BS.

It "works" exactly like mmap() at NULL "works".

It is a potential security leak, because x86-64 screwed up the
architecture definition in this area. So it should definitely be
disabled by default, exactly like mmap_min_addr is non-zero by
default.

            Linus
