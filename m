Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3KEMAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:00:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58403 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3KEMAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:00:18 -0500
Date: Tue, 5 Nov 2013 13:00:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Jenny TC <jenny.tc@intel.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: gitorious v3.12-rc1-n900 tree
Message-ID: <20131105120016.GA30670@amd.pavel.ucw.cz>
References: <201310240806.49340@pali>
 <20131024085155.GB28938@earth.universe>
 <201310252039.41026@pali>
 <20131026002500.GA16970@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026002500.GA16970@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried pulling current linux-n900 tree from gitorious.

So far I got:

  CC      sound/soc/codecs/tpa6130a2.o
sound/soc/codecs/tpa6130a2.c: In function 'tpa6130a2_i2c_read':
sound/soc/codecs/tpa6130a2.c:63:3: error: implicit declaration of
function 'i2c_smbus_read_byte_data'
[-Werror=implicit-function-declaration]
sound/soc/codecs/tpa6130a2.c: In function 'tpa6130a2_i2c_write':
sound/soc/codecs/tpa6130a2.c:84:3: error: implicit declaration of
function 'i2c_smbus_write_byte_data'
[-Werror=implicit-function-declaration]
sound/soc/codecs/tpa6130a2.c: At top level:
sound/soc/codecs/tpa6130a2.c:479:1: warning: data definition has no
type or storage class [enabled by default]
sound/soc/codecs/tpa6130a2.c:479:1: warning: type defaults to 'int' in
declaration of 'module_i2c_driver' [-Wimplicit-int]
sound/soc/codecs/tpa6130a2.c:479:1: warning: parameter names (without
types) in function declaration [enabled by default]
sound/soc/codecs/tpa6130a2.c:469:26: warning: 'tpa6130a2_i2c_driver'
defined but not used [-Wunused-variable]
cc1: some warnings being treated as errors
make[3]: *** [sound/soc/codecs/tpa6130a2.o] Error 1
make[2]: *** [sound/soc/codecs] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2
make: *** Waiting for unfinished jobs....
  CC      drivers/media/i2c/smia/smiaregs.o
drivers/media/i2c/smia/smiaregs.c: In function 'smia_i2c_read_reg':
drivers/media/i2c/smia/smiaregs.c:518:2: error: implicit declaration
of function 'i2c_transfer' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [drivers/media/i2c/smia/smiaregs.o] Error 1

I'll turn off respective config options to get rid of those. Now I'm
getting

  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
drivers/built-in.o: In function `OMAPLFBGetLibFuncAddr':
:(.text+0x58280): undefined reference to `PVRGetDisplayClassJTable'
make: *** [vmlinux] Error 1
Command exited with non-zero status 2

...will get rid config of CONFIG_PVR next. Now it compiles...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
