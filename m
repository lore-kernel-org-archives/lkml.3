Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3LPMXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:23:54 -0500
Received: from smtp206.alice.it ([82.57.200.102]:51944 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab3LPMXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:51 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 07:23:51 EST
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-kernel@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        "J . R . Mauro" <jrm8005@gmail.com>
Subject: [PATCH] scripts/Lindent: fix formatting primitive types
Date: Mon, 16 Dec 2013 13:18:07 +0100
Message-Id: <1387196287-25972-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.8.5.1
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make Lindent recognize and format properly at least the commonly used
primitive types.

Something like this has been suggested before by J.R. Mauro:
https://lkml.org/lkml/2008/10/14/233

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Hi,

I had this local change and I felt like sharing it.

Another way of doing this kind of setup would be to put options into an
indent.pro file and make the INDENT_PROFILE env variable point to it.

BTW, I realize this kind of changes could easily go out of control, I was
almost going to generate the list of types (and qualifier) by parsing header
files, so I'll understand if you just drop it.

Ciao,
   Antonio

 scripts/Lindent | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/Lindent b/scripts/Lindent
index 9c4b3e2..7531d7c 100755
--- a/scripts/Lindent
+++ b/scripts/Lindent
@@ -1,5 +1,14 @@
 #!/bin/sh
 PARAM="-npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1"
+TYPES="-T size_t \
+ -T s8 -T s16 -T s32 -T s64 \
+ -T __s8 -T __s16 -T __s32 -T __s64 \
+ -T u8 -T u16 -T u32 -T u64 \
+ -T __u8 -T __u16 -T __u32 -T __u64 \
+ -T __be16 -T __be32 -T __be64 \
+ -T __le16 -T __le32 -T __le64 \
+ -T int8_t -T int16_t -T int32_t -T int64_t \
+ -T u_int8_t -T u_int16_t -T u_int32_t -T u_int64_t"
 RES=`indent --version`
 V1=`echo $RES | cut -d' ' -f3 | cut -d'.' -f1`
 V2=`echo $RES | cut -d' ' -f3 | cut -d'.' -f2`
@@ -15,4 +24,4 @@ elif [ $V1 -eq 2 ]; then
     fi
   fi
 fi
-indent $PARAM "$@"
+indent $PARAM $TYPES "$@"
-- 
1.8.5.1

