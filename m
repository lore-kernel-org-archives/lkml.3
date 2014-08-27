Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbaH0N0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:26:44 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:46196 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592AbaH0N0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:26:43 -0400
In-Reply-To: <1408957395-404-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com> <1408957395-404-6-git-send-email-andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3 5/5] [S390] zcrypt: use seq_hex_dump() to dump buffers
X-KeepSent: B08508D1:309A6473-C1257D41:004949B0;
 type=4; name=$KeepSent
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Helge Deller <deller@gmx.de>, Herbert Xu <herbert@gondor.apana.org.au>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
X-Mailer: Lotus Notes Release 8.5.3FP4 Septem 15, 2011
Message-ID: <OFB08508D1.309A6473-ONC1257D41.004949B0-C1257D41.0049D541@de.ibm.com>
From: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Date: Wed, 27 Aug 2014 15:26:36 +0200
X-MIMETrack: Serialize by Router on D06ML044/06/M/IBM(Release 8.5.3FP5IF1HF3|November 07, 2013) at
 27/08/2014 15:26:37
MIME-Version: 1.0
Content-type: multipart/mixed; 
	Boundary="0__=4EBBF7D2DFDACF208f9e8a93df938690918c4EBBF7D2DFDACF20"
Content-Disposition: inline
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082713-0342-0000-0000-000000DDA4CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0__=4EBBF7D2DFDACF208f9e8a93df938690918c4EBBF7D2DFDACF20
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: quoted-printable


I have verified and tested the patch for the zcrypt part.
OK from my side. You can add my Acked-by.
Acked-by: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>

Thanks

Mit freundlichen Gr=FC=DFen / Kind regards

Ingo Tuchscherer

Software Development - Linux on System z
IBM Systems &Technology Group
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
 Phone:            +49-7031-16-1986                 IBM Deutschland    =
                      (Embedded 
                                                                       =
                    image moved 
                                                                       =
                       to file: 
                                                                       =
                  pic53004.gif) 
                                                                       =
                                
 E-Mail:           ingo.tuchscherer@de.ibm.com      Schoenaicher Str. 2=
20                              
                                                                       =
                                
                                                    71032 Boeblingen   =
                                
                                                                       =
                                
                                                    Germany            =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
                                                                       =
                                
 IBM Deutschland                                                       =
                                
 Research &                                                            =
                                
 Development                                                           =
                                
 GmbH /                                                                =
                                
 Vorsitzender des                                                      =
                                
 Aufsichtsrats:                                                        =
                                
 Martina Koederitz                                                     =
                                
                                                                       =
                                
 Gesch=E4ftsf=FChrung:                                                 =
                                    
 Dirk Wittkopp                                                         =
                                
 Sitz der                                                              =
                                
 Gesellschaft:                                                         =
                                
 B=F6blingen /                                                         =
                                  
 Registergericht:                                                      =
                                
 Amtsgericht                                                           =
                                
 Stuttgart, HRB                                                        =
                                
 243294                                                                =
                                
                                                                       =
                                





From:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:	Tadeusz Struk <tadeusz.struk@intel.com>, Herbert Xu
            <herbert@gondor.apana.org.au>, Mauro Carvalho Chehab
            <m.chehab@samsung.com>, Helge Deller <deller@gmx.de>, Ingo
            Tuchscherer/Germany/IBM@IBMDE, Alexander Viro
            <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Jo=
e
            Perches <joe@perches.com>, Marek Vasut <marex@denx.de>,
Cc:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:	08/25/2014 11:03 AM
Subject:	[PATCH v3 5/5] [S390] zcrypt: use seq_hex_dump() to dump
            buffers



Instead of custom approach let's use recently introduced seq_hex_dump()=

helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/s390/crypto/zcrypt_api.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c
b/drivers/s390/crypto/zcrypt_api.c
index 0e18c5d..d1f9983 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1203,16 +1203,8 @@ static void sprinthx(unsigned char *title, struc=
t
seq_file *m,
 static void sprinthx4(unsigned char *title, struct seq_file *m,
 		 		       unsigned int *array, unsigned int len)
 {
-		 int r;
-
 		 seq_printf(m, "\n%s\n", title);
-		 for (r =3D 0; r < len; r++) {
-		 		 if ((r % 8) =3D=3D 0)
-		 		 		 seq_printf(m, "    ");
-		 		 seq_printf(m, "%08X ", array[r]);
-		 		 if ((r % 8) =3D=3D 7)
-		 		 		 seq_putc(m, '\n');
-		 }
+		 seq_hex_dump(m, "    ", DUMP_PREFIX_NONE, 32, 4, array, len,
false);
 		 seq_putc(m, '\n');
 }

--
2.1.0

=

--0__=4EBBF7D2DFDACF208f9e8a93df938690918c4EBBF7D2DFDACF20
Content-type: image/gif; 
	name="pic53004.gif"
Content-Disposition: attachment; filename="pic53004.gif"
Content-transfer-encoding: base64

R0lGODlhVwAeAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8ER3u8bGxv///wAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAP/78KCgpICAgP8AAAD/AP//AAAA//8A/wD//////yH5BAAAAAAALAAAAABXAB4A
hwAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8ER3u8bGxv///wAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/7
8KCgpICAgP8AAAD/AP//AAAA//8A/wD//////wj+ABcoGEiwYMEFDAQaXGhwAUIGEBMyLBixIsSJ
By1qVIiRIEKOHRc+hAiS4ciKJU1qXMmypcuXMGPKnEmzps2bLlNO/Biy40OdBlf2VHByJVCREoeq
TOrT4tGMOKNKnUq1qtWrDBjmDIoSacWOFpve1NqypNOFGsUyXYq1rdu3cOO2JMvyKdq0Te0WnUnX
qFKiQkUebOhVruHDiBPD7Lvx796sDddmLFyT8dm/gaFOvBhZsefPoN9a7kqRdOmvnVNGpExzdESz
pj2G7QxZNmeooXPr3o1aAUmlPP/ePToSZG+2F1dLxhhcuG3ivU+qzZpVIHXecH0PTI5dNHXtdmUZ
h9/5mnnXotOvUx8PmP3Bk9C/4iU/2zeDgAA7

--0__=4EBBF7D2DFDACF208f9e8a93df938690918c4EBBF7D2DFDACF20--

