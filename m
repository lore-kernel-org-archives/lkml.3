Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaIAPqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:46:37 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62141 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaIAPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:46:34 -0400
Message-ID: <540494D6.40701@gmail.com>
Date: Mon, 01 Sep 2014 23:46:30 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: eparis@redhat.com, paulmck@linux.vnet.ibm.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        paul.gortmaker@windriver.com, zhenglong.cai@cs2c.com.cn,
        khilman@linaro.org, ak@linux.intel.com, mcgrof@suse.com,
        fabf@skynet.be, "dhowells@redhat.com" <dhowells@redhat.com>,
        pefoley2@pefoley.com, mgorman@suse.de, biederm@xmission.com,
        "hpa@zytor.com" <hpa@zytor.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] init/Kconfig: Add ENDIAN attributes for all architectures
 using
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some individual modules want to know the architecture's endian attribute
during config time, or may cause compiling break, one sample is below:
(with allm dconfig under microblaze):

    CC [M]  drivers/isdn/hisax/nj_s.o
  drivers/isdn/hisax/nj_s.c: In function 'setup_netjet_s':
  drivers/isdn/hisax/nj_s.c:265:2: error: #error "not running on big endian machines now"
   #error "not running on big endian machines now"

So add endian attributes for all architectures using (next, will let all
architectures choose their endians during config time).

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 init/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index ac033c3..f301cc8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -23,6 +23,12 @@ config CONSTRUCTORS
 config IRQ_WORK
 	bool
 
+config CPU_LITTLE_ENDIAN
+	bool
+
+config CPU_BIG_ENDIAN
+	bool
+
 config BUILDTIME_EXTABLE_SORT
 	bool
 
-- 
1.7.11.7
