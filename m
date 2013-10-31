Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3JaBpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:45:45 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40031 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3JaBpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:45:44 -0400
X-Spam-Score: -100.8
Message-ID: <5271B609.90805@asianux.com>
Date: Thu, 31 Oct 2013 09:44:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        "vgupta@synopsys.com" <vgupta@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        speakup@braille.uwo.ca,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: include: asm: define empty SERIAL_PORT_DFNS in serial.h
References: <5267406C.9030805@asianux.com> <20131025052926.GA26786@kroah.com> <526BC113.3040003@asianux.com> <5271B1D2.6020301@asianux.com>
In-Reply-To: <5271B1D2.6020301@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some architectures (e.g. arc, openrisc), BASE_BAUD isn't constant
And SERIAL_PORT_DFNS always use BASE_BAUND, and also all drivers use
SERIAL_PORT_DFNS to initialize static variables, statically.

So need define SERIAL_PORT_DFNS as empty to tell drivers they don't
support SERIAL_PORT_DFNS (mostly like frv and parisc did), or can not
pass compiling

The related error (allmodconfig for arc with gcc-4.8.0):

    CC [M]  drivers/staging/speakup/serialio.o
  drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
    SERIAL_PORT_DFNS
    ^
  drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[0].baud_base')
  drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
  drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[1].baud_base')
  drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
  drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[2].baud_base')
  drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
  drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[3].baud_base')


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/serial.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arc/include/asm/serial.h b/arch/arc/include/asm/serial.h
index 602b097..f18b772 100644
--- a/arch/arc/include/asm/serial.h
+++ b/arch/arc/include/asm/serial.h
@@ -32,4 +32,6 @@
 #define BASE_BAUD	(arc_get_core_freq() / 16 / 3)
 #endif
 
+#define			SERIAL_PORT_DFNS
+
 #endif /* _ASM_ARC_SERIAL_H */
-- 
1.7.7.6
