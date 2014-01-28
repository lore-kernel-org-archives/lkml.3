Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaA1Xhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:37:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50736 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbaA1Xhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:37:34 -0500
Date: Wed, 29 Jan 2014 00:37:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140128233723.GP815@pd.tnic>
References: <52E7D9FF.1080506@nod.at>
 <52E7DB15.3090808@zytor.com>
 <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
 <20140128170507.GA16279@gmail.com>
 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
 <20140128194823.GA18702@gmail.com>
 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
 <20140128201536.GB5178@pd.tnic>
 <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
 <20140128204906.GK815@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140128204906.GK815@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 09:49:06PM +0100, Borislav Petkov wrote:
> On Tue, Jan 28, 2014 at 12:25:15PM -0800, Linus Torvalds wrote:
> > Probably. And then we should make sure that allyesconfig/allmodconfig
> > don't pick it.
> 
> I'd need to think about that a bit longer as scripts/kconfig/conf.c goes
> and sets those. Unless someone has a better idea...

Maybe we can do something simple like this, it works here. We could
even generate a random name for the all.config file so that there are
no conflicts with existing stuff and even test for its presence. Or we
could hide all that in a script and so on and so on...

---
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 844bc9da08da..76e889fc6384 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -77,7 +77,9 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
 
 allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
-	$< --$@ $(Kconfig)
+	$(shell echo "# CONFIG_DEBUG_INFO is not set" > /tmp/all.config)
+	$(Q)KCONFIG_ALLCONFIG=/tmp/all.config $< --$@ $(Kconfig)
+	$(Q)rm -rf /tmp/all.config
 
 PHONY += listnewconfig olddefconfig oldnoconfig savedefconfig defconfig
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
