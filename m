Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbaJaXsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:48:46 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60294 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbaJaXso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:48:44 -0400
Date: Fri, 31 Oct 2014 16:48:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: [git pull] Input updates for 3.18-rc0
Message-ID: <20141031234839.GG32331@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a bunch of
fixes for minor defects reported by Coverity, a few driver fixups and
revert of i8042.nomux change so that we are once again enable active MUX
mode if box claims to support it.

Changelog:
---------

Alexandre Courbot (1):
      Input: soc_button_array - update calls to gpiod_get*()

Dmitry Eremin-Solenikov (1):
      Input: wm97xx - adapt parameters to tosa touchscreen.

Dmitry Torokhov (6):
      Input: opencores-kbd - fix error handling
      Input: ims-pcu - fix dead code in ims_pcu_ofn_reg_addr_store()
      Input: vsxxxaa - fix code dropping bytes from queue
      Input: psmouse - remove unneeded check in psmouse_reconnect()
      Input: max77693-haptic - fix potential overflow
      Revert "Input: i8042 - disable active multiplexing by default"

Hans de Goede (1):
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544

Linus Walleij (1):
      Input: stmpe-keypad - fix valid key line bitmask

Tobias Klauser (2):
      Input: altera_ps2 - write to correct register when disabling interrupts
      Input: altera_ps2 - use correct type for irq return value


Diffstat:
--------

 Documentation/kernel-parameters.txt     |   2 +-
 drivers/input/keyboard/opencores-kbd.c  |   2 +-
 drivers/input/keyboard/stmpe-keypad.c   |   2 +-
 drivers/input/misc/ims-pcu.c            |   2 +-
 drivers/input/misc/max77693-haptic.c    |   5 +-
 drivers/input/misc/soc_button_array.c   |   2 +-
 drivers/input/mouse/psmouse-base.c      |   7 -
 drivers/input/mouse/vsxxxaa.c           |   2 +-
 drivers/input/serio/altera_ps2.c        |   4 +-
 drivers/input/serio/i8042-x86ia64io.h   | 297 +++++++++++++++++++++++++++++++-
 drivers/input/serio/i8042.c             |   2 +-
 drivers/input/touchscreen/wm97xx-core.c |   4 +-
 12 files changed, 302 insertions(+), 29 deletions(-)

-- 
Dmitry

