Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaI2US2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:18:28 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:59219 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbaI2US0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:18:26 -0400
Message-ID: <1412021904.6334.97.camel@x220>
Subject: Re: [PATCH] lib: rename TEST_MODULE to TEST_LKM
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 22:18:24 +0200
In-Reply-To: <1411496822.31476.1.camel@nebuchadnezzar>
References: <1411455508-11958-1-git-send-email-valentinrothberg@gmail.com>
	 <5421A4B4.1040604@infradead.org> <1411492210.30136.15.camel@nebuchadnezzar>
	 <5421A9D5.8020503@infradead.org> <1411496822.31476.1.camel@nebuchadnezzar>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Sep 2014 20:18:24.0521 (UTC) FILETIME=[8595A790:01CFDC22]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Perhaps Kees hasn't seen this yet.]

On Tue, 2014-09-23 at 20:27 +0200, Valentin Rothberg wrote:
> On mar., 2014-09-23 at 10:11 -0700, Randy Dunlap wrote:
> > On 09/23/14 10:10, Valentin Rothberg wrote:
> > > On mar., 2014-09-23 at 09:49 -0700, Randy Dunlap wrote:
> > >> On 09/22/14 23:58, Valentin Rothberg wrote:
> > >>> The "_MODULE" suffix is reserved for tristates compiled as
> > >>> loadable kernel modules (LKM). The "TEST_MODULE" feature thereby
> > >>
> > >> Is that documented anywhere?
> > > 
> > > Sadly this is not made explicit, but the Kconfig code documents it. The
> > > following code (./scripts/kconfig/confdata.c) is used to generate the
> > > autoconf.h header file during the build process. When a feature is
> > > selected as a kernel module ('m'), it is suffixed with "_MODULE" to
> > > indicate it. 
> > > 
> > > »   »   switch (*value) {
> > > »   »   case 'n':
> > > »   »   »   break;
> > > »   »   case 'm':
> > > »   »   »   suffix = "_MODULE";
> > > »   »   »   /* fall through */
> > > 
> > >> Was this causing some kind of problem or error?  Please tell us what that was if so.
> > > 
> > > It causes problems for static code analysis, which assumes a consistent
> > > use of the "_MODULE" suffix. 
> > > 
> > > Another possible change would be to rename the reference in the Makefile
> > > to "TEST_MODULE_MODULE". Personally, I prefer my proposed patch.
> > 
> > Sure, your patch is fine, but we need to know *why* the patch is needed.
> 
> Thank you for pointing that out. I will take care to give more
> information in future patches.
> 
> Thanks,
>  Valentin
> 
> > Thanks.
> > 
> > >>
> > >>
> > >>> violates this convention. The feature is used to compile the
> > >>> lib/test_module.c kernel module.
> > >>>
> > >>> This patch renames the feature and its reference in a Makefile
> > >>> to "TEST_LKM", which still expresses the test of a LKM.

Maybe something like "TEST_MODULE_LOAD"?

> > >>> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
> > >>> ---
> > >>>  lib/Kconfig.debug | 2 +-
> > >>>  lib/Makefile      | 2 +-
> > >>>  2 files changed, 2 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > >>> index 07c2832..db91c97 100644
> > >>> --- a/lib/Kconfig.debug
> > >>> +++ b/lib/Kconfig.debug
> > >>> @@ -1627,7 +1627,7 @@ config DMA_API_DEBUG
> > >>>  
> > >>>  	  If unsure, say N.
> > >>>  
> > >>> -config TEST_MODULE
> > >>> +config TEST_LKM
> > >>>  	tristate "Test module loading with 'hello world' module"
> > >>>  	default n
> > >>>  	depends on m
> > >>> diff --git a/lib/Makefile b/lib/Makefile
> > >>> index d6b4bc4..382437a 100644
> > >>> --- a/lib/Makefile
> > >>> +++ b/lib/Makefile
> > >>> @@ -31,7 +31,7 @@ obj-y += string_helpers.o
> > >>>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
> > >>>  obj-y += kstrtox.o
> > >>>  obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
> > >>> -obj-$(CONFIG_TEST_MODULE) += test_module.o
> > >>> +obj-$(CONFIG_TEST_LKM) += test_module.o

Perhaps we should rename that file likewise?

> > >>>  obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
> > >>>  obj-$(CONFIG_TEST_BPF) += test_bpf.o
> > >>>  obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o

If something like this gets applied a follow up patch to make the kbuild
system reject Kconfig symbols ending in _MODULE might be nice.


Paul Bolle

