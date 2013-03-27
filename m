Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3C0QZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:25:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:49971 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3C0QZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:25:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="309260915"
Date: Thu, 28 Mar 2013 00:25:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparclinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alan Ott <alan@signal11.us>, David Howells <dhowells@redhat.com>
Subject: Re: usr/include/linux/types.h:27:1: error: unknown type name '__u16'
Message-ID: <20130327162506.GA10127@localhost>
References: <5152d3ed.vW9X0QzDTVkW7Gck%fengguang.wu@intel.com>
 <20130327154453.GA27576@localhost>
 <20130327155134.GA24155@kroah.com>
 <20130327161505.GA5045@localhost>
 <alpine.LNX.2.00.1303271718550.23442@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1303271718550.23442@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:19:42PM +0100, Jiri Kosina wrote:
> On Thu, 28 Mar 2013, Fengguang Wu wrote:
> 
> > > As you are getting errors when building Documentation files, I don't
> > > think this is a staging tree specific issue, as I haven't changed
> > > anything in that directory that I can see.
> > > 
> > > So it's probably something else.
> > 
> > It's not a Documentation build, even though many of the errors are
> > related to Documentation/*.
> > 
> > Here is another build. This time the errors are triggered from
> > samples/hidraw/hid-example.c.
> > 
> > Add CC to hidraw authors and David who is very good at the header stuffs.
> 
> What tree is that?

It's linux-next.

> It builds fine for me here on current Linus' tree:

Yeah, however it fails in ARCH=sparc allyesconfig builds.

It's not a problem specific to samples/hidraw/. It does serve as a
good example. :)

Thanks,
Fengguang

> 	$ make samples/hidraw/
> 	make[1]: Nothing to be done for `all'.
> 	make[1]: Nothing to be done for `relocs'.
> 	  CHK     include/generated/uapi/linux/version.h
> 	  CHK     include/generated/utsrelease.h
> 	  CALL    scripts/checksyscalls.sh
> 	  CC      scripts/mod/devicetable-offsets.s
> 	  GEN     scripts/mod/devicetable-offsets.h
> 	  HOSTCC  scripts/mod/file2alias.o
> 	  HOSTLD  scripts/mod/modpost
> 	  HOSTCC  samples/hidraw/hid-example
> 	$
> > 
> > Thanks,
> > Fengguang
> > ---
> > 
> > /usr/bin/make -C source O=/home/wfg/sound/obj-compiletest ARCH=sparc CROSS_COMPILE=/usr/local/gcc-4.6.3-nolibc/sparc-linux/bin/sparc-linux- -j32
> > make: Entering directory `/c/wfg/sound'
> >   GEN     /cc/wfg/sound-compiletest/Makefile
> >   CHK     include/generated/uapi/linux/version.h
> >   CC      scripts/mod/devicetable-offsets.s
> >   GEN     scripts/mod/devicetable-offsets.h
> >   HOSTCC  scripts/mod/file2alias.o
> >   HOSTLD  scripts/mod/modpost
> >   Using /c/wfg/sound as source for kernel
> >   CHK     include/generated/utsrelease.h
> >   CALL    /c/wfg/sound/scripts/checksyscalls.sh
> >   CHK     include/generated/compile.h
> >   CHK     kernel/config_data.h
> >   CHK     include/generated/uapi/linux/version.h
> >   HOSTCC  samples/hidraw/hid-example
> > In file included from /c/wfg/sound/samples/hidraw/hid-example.c:13:0:
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:27:1: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:28:1: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:29:1: error: unknown type name ‘__u32’
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:30:1: error: unknown type name ‘__u32’
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:31:1: error: unknown type name ‘__u64’
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:32:1: error: unknown type name ‘__u64’
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:34:1: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/types.h:35:1: error: unknown type name ‘__u32’
> > In file included from /c/wfg/sound/samples/hidraw/hid-example.c:14:0:
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:24:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:25:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:26:2: error: unknown type name ‘__s32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:40:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:41:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:42:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:43:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:66:2: error: unknown type name ‘__s32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:67:2: error: unknown type name ‘__s32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:68:2: error: unknown type name ‘__s32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:69:2: error: unknown type name ‘__s32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:70:2: error: unknown type name ‘__s32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:71:2: error: unknown type name ‘__s32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:91:2: error: unknown type name ‘__u8’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:92:2: error: unknown type name ‘__u8’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:93:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:94:2: error: unknown type name ‘__u32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:95:2: error: unknown type name ‘__u8’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:958:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:959:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:968:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:969:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:985:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:986:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:987:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:988:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:997:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1008:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1009:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1024:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1025:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1027:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1028:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1030:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1031:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1053:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1054:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1055:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1056:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1057:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1061:2: error: unknown type name ‘__u32’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1062:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1074:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1075:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1102:2: error: unknown type name ‘__u16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1103:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/input.h:1104:2: error: unknown type name ‘__u16’
> > In file included from /c/wfg/sound/samples/hidraw/hid-example.c:15:0:
> > /cc/wfg/sound-compiletest/usr/include/linux/hidraw.h:22:2: error: unknown type name ‘__u32’
> > /cc/wfg/sound-compiletest/usr/include/linux/hidraw.h:23:2: error: unknown type name ‘__u8’
> > /cc/wfg/sound-compiletest/usr/include/linux/hidraw.h:27:2: error: unknown type name ‘__u32’
> > /cc/wfg/sound-compiletest/usr/include/linux/hidraw.h:28:2: error: unknown type name ‘__s16’
> > /cc/wfg/sound-compiletest/usr/include/linux/hidraw.h:29:2: error: unknown type name ‘__s16’
> > make[3]: *** [samples/hidraw/hid-example] Error 1
> > make[2]: *** [samples/hidraw] Error 2
> > make[1]: *** [vmlinux] Error 2
> > make: *** [sub-make] Error 2
> > make: Leaving directory `/c/wfg/sound'
> > 
> 
> -- 
> Jiri Kosina
> SUSE Labs
