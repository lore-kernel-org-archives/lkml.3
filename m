Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaHFNAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:00:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57202 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaHFNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:00:29 -0400
Date: Wed, 6 Aug 2014 18:30:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] x86: mtrr/cyrix.c : Remove typedef arr_state_t
Message-ID: <20140806130025.GA8156@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for arr_state_t.
Also the name of the struct is changed to drop the _t, to make the
name look less typedef-like.

The following Coccinelle semantic patch detects the case.

@tn1@
type td;
@@

typedef struct { ... } td;

@script:python tf@
td << tn1.td;
tdres;
@@

coccinelle.tdres = td;

@@
type tn1.td;
identifier tf.tdres;
@@

-typedef
 struct
+  tdres
   { ... }
-td
 ;

@@
type tn1.td;
identifier tf.tdres;
@@

(
-td
+ struct tdres
|
 const
- td
+ struct tdres
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 arch/x86/kernel/cpu/mtrr/cyrix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 9e451b0..5e8d57d 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -232,13 +232,13 @@ static void cyrix_set_arr(unsigned int reg, unsigned long base,
 	post_set();
 }
 
-typedef struct {
+struct arr_state {
 	unsigned long	base;
 	unsigned long	size;
 	mtrr_type	type;
-} arr_state_t;
+};
 
-static arr_state_t arr_state[8] = {
+static struct arr_state arr_state[8] = {
 	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL},
 	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}
 };
-- 
1.9.1

