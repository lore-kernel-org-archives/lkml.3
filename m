Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaH1RyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:54:20 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41257 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaH1RyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:54:18 -0400
Date: Thu, 28 Aug 2014 23:23:59 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, hverkuil@xs4all.nl,
        "m.chehab" <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: randconfig build error with next-20140828, in
 drivers/media/radio/radio-miropcm20.c
Message-ID: <20140828175359.GA16811@sudip-PC>
References: <CA+r1ZhgU93EfHFNCG60CZ-cJh-9TLN5WcTYMwvErsXFZNgKGLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhgU93EfHFNCG60CZ-cJh-9TLN5WcTYMwvErsXFZNgKGLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Aug 28, 2014 at 09:17:14AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>  CC [M]  drivers/media/radio/radio-miropcm20.o
> drivers/media/radio/radio-miropcm20.c: In function ‘rds_waitread’:
> drivers/media/radio/radio-miropcm20.c:90:3: error: implicit
> declaration of function ‘inb’ [-Werror=implicit-function-declaration]
>    byte = inb(aci->aci_port + ACI_REG_RDS);
>    ^
> drivers/media/radio/radio-miropcm20.c: In function ‘rds_rawwrite’:
> drivers/media/radio/radio-miropcm20.c:106:3: error: implicit
> declaration of function ‘outb’ [-Werror=implicit-function-declaration]
>    outb(byte, aci->aci_port + ACI_REG_RDS);
>    ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/media/radio/radio-miropcm20.o] Error 1
> make[2]: *** [drivers/media/radio] Error 2
> make[1]: *** [drivers/media] Error 2

Hi,
Can you please try the attached patch , for me it solved the error/

thanks
sudip


--SLDf9lqlvOQaIe6s
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 998919e..3309f7c 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <sound/aci.h>
+#include<linux/io.h>
 
 #define RDS_DATASHIFT          2   /* Bit 2 */
 #define RDS_DATAMASK        (1 << RDS_DATASHIFT)

--SLDf9lqlvOQaIe6s--
