Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3ETOkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:40:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44937 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab3ETOkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:40:37 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5199DBE2.5080707@asianux.com>
References: <5199DBE2.5080707@asianux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 20 May 2013 07:40:24 -0700
To: Chen Gang <gang.chen@asianux.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <97dada79-cd78-4799-8f18-ed2bf8eee508@email.android.com>
X-XM-AID: U2FsdGVkX1+lIJS1jkuB43Rl0b/22SHQZtM4I3Ax2dg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0043]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chen Gang <gang.chen@asianux.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] include/linux/posix_acl.h: need 'return NULL' when BUG(), if neither CONFIG_BUG nor HAVE_ARCH_BUG is defined.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Chen Gang <gang.chen@asianux.com> wrote:

>
>If neither CONFIG_BUG nor HAVE_ARCH_BUG is defined, the BUG() will
>defined as empty (e.g. randconfig with MMU for arm s5pv210)
>
>In this case, need 'return NULL' to let upper caller knows the failure.

Seriously?  The correct fix it would seem is to give a useful default BUG definition.  Say *NULL.

Further we should never hit that code in the first place if it calls BUG.  So upper callers should never get there.

If it is ever possible to get there the callers need to be fixed.

Eric

>Signed-off-by: Chen Gang <gang.chen@asianux.com>
>---
> include/linux/posix_acl.h |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>
>diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
>index 7931efe..2c48d06 100644
>--- a/include/linux/posix_acl.h
>+++ b/include/linux/posix_acl.h
>@@ -104,6 +104,7 @@ static inline struct posix_acl **acl_by_type(struct
>inode *inode, int type)
> 		return &inode->i_default_acl;
> 	default:
> 		BUG();
>+		return NULL;
> 	}
> }
> 
>-- 
>1.7.7.6

