Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab3BLEWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:22:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45812 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761237Ab3BLEWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:22:10 -0500
Message-ID: <5119C34B.70207@zytor.com>
Date: Mon, 11 Feb 2013 20:21:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
 warnings
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org> <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
In-Reply-To: <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/mixed;
 boundary="------------040703010408040104010407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040703010408040104010407
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/11/2013 07:33 PM, Linus Torvalds wrote:
> On Mon, Feb 11, 2013 at 5:37 PM, tip-bot for H. Peter Anvin
> <hpa@zytor.com> wrote:
>>
>> However, we can declare a bitfield using sizeof(), which is legal
>> because sizeof() is a constant expression.  This quiets the warning,
>> although the code generated isn't 100% identical from the baseline
>> before 96477b4 x86-32: Add support for 64bit get_user():
> 
> Christ. This is so ugly that it's almost a work of art.

:)

> Has anybody run this past any gcc developers? And if so, did they run
> away screaming?

I haven't no... H.J., any comments on this patch?

	-hpa



--------------040703010408040104010407
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="Attached Message"

Return-Path: <tipbot@zytor.com>
Received: from terminus.zytor.com (localhost [127.0.0.1])
	by terminus.zytor.com (8.14.5/8.14.5) with ESMTP id r1C1bqh8025117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Mon, 11 Feb 2013 17:37:57 -0800
Received: (from tipbot@localhost)
	by terminus.zytor.com (8.14.5/8.14.5/Submit) id r1C1bqMV025114;
	Mon, 11 Feb 2013 17:37:52 -0800
Date: Mon, 11 Feb 2013 17:37:52 -0800
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jamie@shareable.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jamie@shareable.org, torvalds@linux-foundation.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de
In-Reply-To: <20130209110031.GA17833@n2100.arm.linux.org.uk>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
  warnings
Git-Commit-ID: b390784dc1649f6e6c5e66e5f53c21e715ccf39b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Precedence: bulk
X-Spam-Status: No, score=-0.3 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	DATE_IN_FUTURE_96_Q autolearn=no version=3.3.2
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on terminus.zytor.com
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 17:37:58 -0800 (PST)

Commit-ID:  b390784dc1649f6e6c5e66e5f53c21e715ccf39b
Gitweb:     http://git.kernel.org/tip/b390784dc1649f6e6c5e66e5f53c21e715ccf39b
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 11 Feb 2013 16:27:28 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 11 Feb 2013 17:26:51 -0800

x86, mm: Use a bitfield to mask nuisance get_user() warnings

Even though it is never executed, gcc wants to warn for casting from
a large integer to a pointer.  Furthermore, using a variable with
__typeof__() doesn't work because __typeof__ retains storage
specifiers (const, restrict, volatile).

However, we can declare a bitfield using sizeof(), which is legal
because sizeof() is a constant expression.  This quiets the warning,
although the code generated isn't 100% identical from the baseline
before 96477b4 x86-32: Add support for 64bit get_user():

[x86-mb is baseline, x86-mm is this commit]

   text      data        bss     filename
113716147  15858380   35037184   tip.x86-mb/o.i386-allconfig/vmlinux
113716145  15858380   35037184   tip.x86-mm/o.i386-allconfig/vmlinux
 12989837   3597944   12255232   tip.x86-mb/o.i386-modconfig/vmlinux
 12989831   3597944   12255232   tip.x86-mm/o.i386-modconfig/vmlinux
  1462784    237608    1401988   tip.x86-mb/o.i386-noconfig/vmlinux
  1462837    237608    1401964   tip.x86-mm/o.i386-noconfig/vmlinux
  7938994    553688    7639040   tip.x86-mb/o.i386-pae/vmlinux
  7943136    557784    7639040   tip.x86-mm/o.i386-pae/vmlinux
  7186126    510572    6574080   tip.x86-mb/o.i386/vmlinux
  7186124    510572    6574080   tip.x86-mm/o.i386/vmlinux
103747269  33578856   65888256   tip.x86-mb/o.x86_64-allconfig/vmlinux
103746949  33578856   65888256   tip.x86-mm/o.x86_64-allconfig/vmlinux
 12116695  11035832   20160512   tip.x86-mb/o.x86_64-modconfig/vmlinux
 12116567  11035832   20160512   tip.x86-mm/o.x86_64-modconfig/vmlinux
  1700790    380524     511808   tip.x86-mb/o.x86_64-noconfig/vmlinux
  1700790    380524     511808   tip.x86-mm/o.x86_64-noconfig/vmlinux
 12413612   1133376    1101824   tip.x86-mb/o.x86_64/vmlinux
 12413484   1133376    1101824   tip.x86-mm/o.x86_64/vmlinux

Cc: Jamie Lokier <jamie@shareable.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130209110031.GA17833@n2100.arm.linux.org.uk
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uaccess.h | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 1e96326..a8d1265 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -168,31 +168,29 @@ do {						      \
 #define get_user(x, ptr)						\
 ({									\
 	int __ret_gu;							\
-	unsigned long __val_gu;						\
-	unsigned long long __val_gu8;					\
+	struct {							\
+		unsigned long long __val_n : 8*sizeof(*(ptr));		\
+	} __val_gu;							\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
-		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(1, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	case 2:								\
-		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(2, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	case 4:								\
-		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(4, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	case 8:								\
-		__get_user_8(__ret_gu, __val_gu8, ptr);			\
+		__get_user_8(__ret_gu, __val_gu.__val_n, ptr);		\
 		break;							\
 	default:							\
-		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(X, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	}								\
-	if (sizeof(*(ptr)) == 8)					\
-		(x) = (__typeof__(*(ptr)))__val_gu8;			\
-	else								\
-		(x) = (__typeof__(*(ptr)))__val_gu;			\
+	(x) = (__typeof__(*(ptr)))__val_gu.__val_n;			\
 	__ret_gu;							\
 })
 

--------------040703010408040104010407--
