Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab3CLLHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:07:36 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54439 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3CLLHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:07:35 -0400
Message-ID: <513F0C74.4030101@hitachi.com>
Date: Tue, 12 Mar 2013 20:07:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522> <20130312082112.GB30665@gmail.com>
In-Reply-To: <20130312082112.GB30665@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/12 17:21), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> @@ -31,7 +32,7 @@
>>  #error Wordsize not 32 or 64
>>  #endif
>>  
>> -static inline u64 hash_64(u64 val, unsigned int bits)
>> +static __kprobes inline u64 hash_64(u64 val, unsigned int bits)
>>  {
>>  	u64 hash = val;
> 
> We should also, really, really fix the '__kprobes' misnomer and switch to 
> the '__noprobe' pattern or so. The naming does not make it obvious at all 
> that what we do here is to turn _off_ kprobing of select functions...

Agreed.

> The only complication is that __kprobes is now present in 600+ places, 
> which will create merge conflicts. If you remind me during the next merge 
> window I can generate the rename on the spot and send it to Linus without 
> anyone having to carry the patch for too long.

Let me confirm that I just move __kprobes definition into
compiler.h this time, and ping you when the next merge
window opens, is that correct?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


