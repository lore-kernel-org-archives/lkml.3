Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaFJV2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:28:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37402 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaFJV2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:28:53 -0400
Message-ID: <53977885.8010709@zytor.com>
Date: Tue, 10 Jun 2014 14:28:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mingo@kernel.org,
        luto@amacapital.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
CC: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/vdso] x86, vdso: Use <tools/le_byteshift.h> for littleendian
 access
References: <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>	<tip-bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7@git.kernel.org> <20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org>
In-Reply-To: <20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------020308000302040409010808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020308000302040409010808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/10/2014 01:50 PM, Andrew Morton wrote:
> On Fri, 6 Jun 2014 15:00:29 -0700 "tip-bot for H. Peter Anvin" <tipbot@zytor.com> wrote:
> 
>> Commit-ID:  bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7
>> Gitweb:     http://git.kernel.org/tip/bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7
>> Author:     H. Peter Anvin <hpa@linux.intel.com>
>> AuthorDate: Fri, 6 Jun 2014 14:30:37 -0700
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Fri, 6 Jun 2014 14:54:54 -0700
>>
>> x86, vdso: Use <tools/le_byteshift.h> for littleendian access
> 
> Getting closer.
> 
> In file included from arch/x86/vdso/vdso2c.c:80:
> arch/x86/vdso/vdso2c.h: In function 'go64':
> arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'
> /tmp/cc04m2KE.o: In function `go':
> vdso2c.c:(.text+0xf69): undefined reference to `htole16'
> vdso2c.c:(.text+0x12e6): undefined reference to `htole16'
> 

Want to test this patch before I commit it?

	-hpa


--------------020308000302040409010808
Content-Type: text/x-patch;
 name="0001-x86-vdso-Remove-one-final-use-of-htole16.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-x86-vdso-Remove-one-final-use-of-htole16.patch"

>From 15ea1a528e08c6bc322f10686ec8d73ba413b941 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 10 Jun 2014 14:25:26 -0700
Subject: [PATCH] x86, vdso: Remove one final use of htole16()

One final use of the macros from <endian.h> which are not available on
older system.  In this case we had one sole case of *writing* a
littleendian number, but the number is SHN_UNDEF which is the constant
zero, so rather than dealing with the general case of littleendian
puts here, just document that the constant is zero and be done with
it.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org
---
 arch/x86/vdso/vdso2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 8a074637a576..d9f6f61aef1c 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -116,7 +116,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	hdr->e_shoff = 0;
 	hdr->e_shentsize = 0;
 	hdr->e_shnum = 0;
-	hdr->e_shstrndx = htole16(SHN_UNDEF);
+	hdr->e_shstrndx = SHN_UNDEF; /* SHN_UNDEF == 0 */
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
-- 
1.9.3


--------------020308000302040409010808--
