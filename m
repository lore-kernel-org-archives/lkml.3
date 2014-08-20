Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaHTQ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:57:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51702 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaHTQ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:57:14 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140820154817.GA21518@redhat.com>
References: <20140820060423.GA14660@glanzmann.de> <20140820062408.GB14660@glanzmann.de> <20140820125630.GA12786@redhat.com> <30d943a9-ba4a-47ee-9333-0ffeea00c3a1@email.android.com> <20140820154817.GA21518@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: REGRESSION: 8fc5b4d: Unable to compile x86_64 kernel with x86_32 userland
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 20 Aug 2014 11:56:14 -0500
To: Vivek Goyal <vgoyal@redhat.com>, Thomas Glanzmann <thomas@glanzmann.de>
CC: LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <f7583da0-c49c-48d9-b69e-0257db583115@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, that is exactly right.  The lack of -m64 is a bug.

On August 20, 2014 10:48:18 AM CDT, Vivek Goyal <vgoyal@redhat.com> wrote:
>On Wed, Aug 20, 2014 at 10:07:01AM -0500, H. Peter Anvin wrote:
>> It says "32-bit mode" which means it is another issue: we are
>dropping -m64 at some point.
>
>Thanks hpa. I am not adding -m64 to kbuild flags at all. So 32bit tool
>chain must be assuming -m32 by default, and probably that's the issue.
>
>Thomas, 
>
>Can you please try attached single line patch and see if it fixes the
>issue for you.
>
>Thanks
>Vivek
>
>
>---
> arch/x86/purgatory/Makefile |    1 +
> 1 file changed, 1 insertion(+)
>
>Index: linux-2.6/arch/x86/purgatory/Makefile
>===================================================================
>--- linux-2.6.orig/arch/x86/purgatory/Makefile	2014-08-20
>11:32:21.723559119 -0400
>+++ linux-2.6/arch/x86/purgatory/Makefile	2014-08-20 11:32:23.654570231
>-0400
>@@ -11,6 +11,7 @@ targets += purgatory.ro
> # sure how to relocate those. Like kexec-tools, use custom flags.
> 
>KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes
>-fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os
>-mcmodel=large
>+KBUILD_CFLAGS += -m$(BITS)
> 
> $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
> 		$(call if_changed,ld)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
