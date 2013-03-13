Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3CMG7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:59:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51140 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3CMG67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:58:59 -0400
Message-ID: <514023AA.4070004@hitachi.com>
Date: Wed, 13 Mar 2013 15:58:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522> <CA+55aFz28CvntOMF-Te0x=gn=XQcU8Zzi6E0iAhZb9mG5J-Ppg@mail.gmail.com>
In-Reply-To: <CA+55aFz28CvntOMF-Te0x=gn=XQcU8Zzi6E0iAhZb9mG5J-Ppg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/13 1:04), Linus Torvalds wrote:
> On Mon, Mar 11, 2013 at 7:22 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> Beacuse hash_64() is called from the get_kprobe() inside
>> int3 handler, kernel causes int3 recursion and crashes if
>> kprobes user puts a probe on it.
>>
>> Usually hash_64() is inlined into caller function, but in
>> some cases, it has instances by gcc's interprocedural
>> constant propagation.
>>
>> This patch adds __kprobes tag on the hash_64()
> 
> NAK. Don't do this. Just force inlining. There's absolutely no way we
> want to start adding __kprobe to random helper functions like this.

I see.

> This isn't even about where "__kprobes" exists and whether we want to
> include the header file. This is about the fact that hash64 has
> absolutely *nothing* to do with kprobes, and we simply shouldn't do
> crap like this regardless of whether we need a new #include or not.

OK, then I'll update it to just use __always_inline.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


