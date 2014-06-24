Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaFXS3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:29:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54895 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbaFXS3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:29:49 -0400
Message-ID: <53A9C391.6030409@zytor.com>
Date: Tue, 24 Jun 2014 11:29:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/vdso: Discard the __bug_table section
References: <2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net> <tip-5f56e7167e6d438324fcba87018255d81e201383@git.kernel.org> <20140622084754.GA15094@gmail.com>
In-Reply-To: <20140622084754.GA15094@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------060901090601010703060005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060901090601010703060005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/22/2014 01:47 AM, Ingo Molnar wrote:
> 
> * tip-bot for Andy Lutomirski <tipbot@zytor.com> wrote:
> 
>> Commit-ID:  5f56e7167e6d438324fcba87018255d81e201383
>> Gitweb:     http://git.kernel.org/tip/5f56e7167e6d438324fcba87018255d81e201383
>> Author:     Andy Lutomirski <luto@amacapital.net>
>> AuthorDate: Wed, 18 Jun 2014 15:59:46 -0700
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Thu, 19 Jun 2014 15:44:51 -0700
>>
>> x86/vdso: Discard the __bug_table section
>>
>> It serves no purpose in user code.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> Link: http://lkml.kernel.org/r/2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>> ---
>>  arch/x86/vdso/vdso-layout.lds.S | 1 +
>>  1 file changed, 1 insertion(+)
> 
> One of the recent x86/urgent vdso commits causes this build failure:
> 
>  Error: too many copied sections (max = 13)
>  make[2]: *** [arch/x86/vdso/vdso-image-64.c] Error 1
>  make[1]: *** [arch/x86/vdso] Error 2
>  make: *** [arch/x86] Error 2
> 
> with the attached config.
> 

Hi Ingo,

Could you try this with the attached patch?

	-hpa



--------------060901090601010703060005
Content-Type: text/x-patch;
 name="0001-x86-vdso-Make-vdso2c-print-the-number-of-sections-ne.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-vdso-Make-vdso2c-print-the-number-of-sections-ne.pa";
 filename*1="tch"

>From e28dc3efe8a8880206e90886cc12649f87fa1848 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 24 Jun 2014 11:26:18 -0700
Subject: [PATCH] x86/vdso: Make vdso2c print the number of sections needed on
 error

If we run out of space for section, at least make the error message
print the amount of space we need so we can actually diagnose it.
Furthermore, the test should be > instead of >= (it is okay to have
exactly the maximum number of sections.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/20140622084754.GA15094@gmail.com
---
 arch/x86/vdso/vdso2c.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index f42e2ddc663d..94158e100f26 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -99,8 +99,9 @@ static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
 	if (!copy)
 		return;
 
-	if (out->count >= out->max_count)
-		fail("too many copied sections (max = %d)\n", out->max_count);
+	if (out->count > out->max_count)
+		fail("too many copied sections (max = %d, need = %d)\n",
+		     out->max_count, out->count);
 
 	if (in_idx == out->in_shstrndx)
 		out->out_shstrndx = out->count;
-- 
1.9.3


--------------060901090601010703060005--
