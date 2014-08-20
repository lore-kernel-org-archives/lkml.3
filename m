Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaHTQVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:21:30 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:46362 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaHTQV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:21:28 -0400
Date: Wed, 20 Aug 2014 18:21:26 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Baoquan He <bhe@redhat.com>,
        Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        WANG Chao <chaowang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        ubuntu@iam.tj
Subject: Re: REGRESSION: 8fc5b4d: Unable to compile x86_64 kernel with x86_32
 userland
Message-ID: <20140820162126.GC25390@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>, Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	WANG Chao <chaowang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
	ubuntu@iam.tj
References: <20140820060423.GA14660@glanzmann.de>
 <20140820062408.GB14660@glanzmann.de>
 <20140820125630.GA12786@redhat.com>
 <30d943a9-ba4a-47ee-9333-0ffeea00c3a1@email.android.com>
 <20140820154817.GA21518@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820154817.GA21518@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

* Vivek Goyal <vgoyal@redhat.com> [2014-08-20 17:48]:
> --- linux-2.6.orig/arch/x86/purgatory/Makefile	2014-08-20 11:32:21.723559119 -0400
> +++ linux-2.6/arch/x86/purgatory/Makefile	2014-08-20 11:32:23.654570231 -0400
> @@ -11,6 +11,7 @@ targets += purgatory.ro
>  # sure how to relocate those. Like kexec-tools, use custom flags.

>  KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os -mcmodel=large
> +KBUILD_CFLAGS += -m$(BITS)

>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)

> Can you please try attached single line patch and see if it fixes the
> issue for you.

I tested the same and it works.

Tested-by: Thomas Glanzmann <thomas@glanzmann.de>

...
  CC      arch/x86/purgatory/purgatory.o
  AS      arch/x86/purgatory/stack.o
  AS      arch/x86/purgatory/setup-x86_64.o
  CC      arch/x86/purgatory/sha256.o
  AS      arch/x86/purgatory/entry64.o
  CC      arch/x86/purgatory/string.o
  LD      arch/x86/purgatory/purgatory.ro
  BIN2C   arch/x86/purgatory/kexec-purgatory.c
...

I also made sure that I backed out the other patch _before_ I tried this one.

Cheers,
        Thomas
