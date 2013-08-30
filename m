Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3H3FCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:02:51 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21322 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3H3FCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:02:50 -0400
X-Spam-Score: -100.9
Message-ID: <52202739.1090806@asianux.com>
Date: Fri, 30 Aug 2013 13:01:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: hjk@hansjkoch.de
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH]  drivers: uio: Kconfig: add MMU dependancy for UIO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The User space I/O drivers are useful, only when user space meaningful
(MMU must be enabled).

So need let it depend on MMU, or can not pass compiling, the related
error (allmodconfig for H8300):

    CC [M]  drivers/uio/uio.o
  drivers/uio/uio.c: In function 'uio_mmap_physical':
  drivers/uio/uio.c:650:2: error: implicit declaration of function 'pgprot_noncached' [-Werror=implicit-function-declaration]
  drivers/uio/uio.c:650:20: error: incompatible types when assigning to type 'pgprot_t' from type 'int'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/uio/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index a81d163..f91ec11 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -1,5 +1,6 @@
 menuconfig UIO
 	tristate "Userspace I/O drivers"
+	depends on MMU
 	help
 	  Enable this to allow the userspace driver core code to be
 	  built.  This code allows userspace programs easy access to
-- 
1.7.7.6
