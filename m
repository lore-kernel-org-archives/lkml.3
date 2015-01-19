Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbbASBML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:12:11 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44374 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbASBMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:12:10 -0500
Message-ID: <54BC59C3.8010208@roeck-us.net>
Date: Sun, 18 Jan 2015 17:11:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        jsrhbz@kanargh.force9.co.uk, christoph.muellner@theobroma-systems.com,
        linux@rasmusvillemoes.dk, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, maxime.coquelin@st.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, martink@posteo.de, tytso@mit.edu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/types] bitops: Add sign_extend8(), 16 and 64 functions
References: <1421083370-24924-1-git-send-email-martink@posteo.de>	<tip-7e9358073d3f0ed0a028c48aa54009b3296dffc9@git.kernel.org> <CA+55aFyc7TbnLBi3rcQDrtkwg9TgDnb5dAfupMGSbTKZC6Xd0g@mail.gmail.com>
In-Reply-To: <CA+55aFyc7TbnLBi3rcQDrtkwg9TgDnb5dAfupMGSbTKZC6Xd0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54BC59E9.01CB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2015 11:54 AM, Linus Torvalds wrote:
> Why?
>

Probably because some of us are, unfortunately, sometimes clueless :-(.

Guenter

> The 8- and 16- bit versions are the same as the 32-bit one. This seems pointless. If you want something where the sign is in bit 3, they all return the same value, just the return type differs, but that's really a *caller* thing, no?
>
>       Linus
>
> On Jan 19, 2015 7:07 AM, "tip-bot for Martin Kepplinger" <tipbot@zytor.com <mailto:tipbot@zytor.com>> wrote:
>
>     Commit-ID:  7e9358073d3f0ed0a028c48aa54009b3296dffc9
>     Gitweb: http://git.kernel.org/tip/7e9358073d3f0ed0a028c48aa54009b3296dffc9
>     Author:     Martin Kepplinger <martink@posteo.de <mailto:martink@posteo.de>>
>     AuthorDate: Mon, 12 Jan 2015 18:22:50 +0100
>     Committer:  Ingo Molnar <mingo@kernel.org <mailto:mingo@kernel.org>>
>     CommitDate: Sun, 18 Jan 2015 20:03:51 +0100
>
>     bitops: Add sign_extend8(), 16 and 64 functions
>
>     This adds helper functions for sign-extending signed values of any
>     lower (hardware-)given size to s8, s16 or s64 respectively, just like
>     sign_extend32() for s32.
>
>     This completes the sign_extend*() API family to work on all bit sizes
>     like most other bitops APIs do.
>
>     Suggested-by: Christoph Muellner <christoph.muellner@theobroma-systems.com <mailto:christoph.muellner@theobroma-systems.com>>
>     Signed-off-by: Martin Kepplinger <martink@posteo.de <mailto:martink@posteo.de>>
>     Reviewed-by: Guenter Roeck <linux@roeck-us.net <mailto:linux@roeck-us.net>>
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org <mailto:peterz@infradead.org>>
>     Cc: John Sullivan <jsrhbz@kanargh.force9.co.uk <mailto:jsrhbz@kanargh.force9.co.uk>>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org <mailto:torvalds@linux-foundation.org>>
>     Cc: Maxime COQUELIN <maxime.coquelin@st.com <mailto:maxime.coquelin@st.com>>
>     Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com <mailto:paulmck@linux.vnet.ibm.com>>
>     Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk <mailto:linux@rasmusvillemoes.dk>>
>     Cc: Theodore Ts'o <tytso@mit.edu <mailto:tytso@mit.edu>>
>     Cc: Andrew Morton <akpm@linux-foundation.org <mailto:akpm@linux-foundation.org>>
>     Link: http://lkml.kernel.org/r/1421083370-24924-1-git-send-email-martink@posteo.de
>     Signed-off-by <http://lkml.kernel.org/r/1421083370-24924-1-git-send-email-martink@posteo.de Signed-off-by>: Ingo Molnar <mingo@kernel.org <mailto:mingo@kernel.org>>
>     ---
>       include/linux/bitops.h | 33 +++++++++++++++++++++++++++++++++
>       1 file changed, 33 insertions(+)
>
>     diff --git a/include/linux/bitops.h b/include/linux/bitops.h
>     index 5d858e0..9c31680 100644
>     --- a/include/linux/bitops.h
>     +++ b/include/linux/bitops.h
>     @@ -161,6 +161,28 @@ static inline __u8 ror8(__u8 word, unsigned int shift)
>       }
>
>       /**
>     + * sign_extend8 - sign extend a 8-bit value using specified bit as sign-bit
>     + * @value: value to sign extend
>     + * @index: 0 based bit index (0<=index<8) to sign bit
>     + */
>     +static inline __s8 sign_extend8(__u8 value, int index)
>     +{
>     +       __u8 shift = 7 - index;
>     +       return (__s8)(value << shift) >> shift;
>     +}
>     +
>     +/**
>     + * sign_extend16 - sign extend a 16-bit value using specified bit as sign-bit
>     + * @value: value to sign extend
>     + * @index: 0 based bit index (0<=index<16) to sign bit
>     + */
>     +static inline __s16 sign_extend16(__u16 value, int index)
>     +{
>     +       __u8 shift = 15 - index;
>     +       return (__s16)(value << shift) >> shift;
>     +}
>     +
>     +/**
>        * sign_extend32 - sign extend a 32-bit value using specified bit as sign-bit
>        * @value: value to sign extend
>        * @index: 0 based bit index (0<=index<32) to sign bit
>     @@ -171,6 +193,17 @@ static inline __s32 sign_extend32(__u32 value, int index)
>              return (__s32)(value << shift) >> shift;
>       }
>
>     +/**
>     + * sign_extend64 - sign extend a 64-bit value using specified bit as sign-bit
>     + * @value: value to sign extend
>     + * @index: 0 based bit index (0<=index<64) to sign bit
>     + */
>     +static inline __s64 sign_extend64(__u64 value, int index)
>     +{
>     +       __u8 shift = 63 - index;
>     +       return (__s64)(value << shift) >> shift;
>     +}
>     +
>       static inline unsigned fls_long(unsigned long l)
>       {
>              if (sizeof(l) == 4)
>

