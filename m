Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3AZPUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 10:20:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52820 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3AZPUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 10:20:19 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130126125208.GC21395@pd.tnic>
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com> <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org> <20130126125208.GC21395@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on CONFIG_CC_OPTIMIZE_FOR_SIZE= y in the 64-bit defconfig
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2013 07:18:26 -0800
To: Borislav Petkov <bp@alien8.de>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        arjan@linux.intel.com, jbeulich@suse.com, ling.ml@alipay.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Message-ID: <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the CPUs Ling is testing on the downsides of -Os probably matter less, in particular since rep movsb works well.

It is questionable as a generic default, though.

The whole -Ok discussion came from that.

Borislav Petkov <bp@alien8.de> wrote:

>On Sat, Jan 26, 2013 at 04:25:57AM -0800, tip-bot for Ma Ling wrote:
>> During the same  time (269.410275674 seconds) IPC from Os is
>> 0.37, O2 is 0.36, Os improved performance 2.7%.
>> 
>> Signed-off-by: Ma Ling <ling.ml@alipay.com>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Jan Beulich <jbeulich@suse.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Link:
>http://lkml.kernel.org/r/1359123061-6139-1-git-send-email-ling.ma@alipay.com
>> [ So, this is a bit symbolic as most people don't use the defconfig,
>>   but the measurements are useful nevertheless so let's commit this
>>   if there are no objections. ]
>
>What about
>
>commit 3a55fb0d9fe8e2f4594329edd58c5fd6f35a99dd
>Author: Kirill Smelkov <kirr@mns.spb.ru>
>Date:   Fri Nov 2 15:41:01 2012 +0400
>
>    Tell the world we gave up on pushing CC_OPTIMIZE_FOR_SIZE
>
>?
>
>Reportedly, -Os generates suboptimal code in certain cases and we
>advise
>against it with this patch.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
