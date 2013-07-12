Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3GLAui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:50:38 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39439 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab3GLAub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:50:31 -0400
Message-ID: <51DF52D4.20500@hitachi.com>
Date: Fri, 12 Jul 2013 09:50:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DE8799.9020904@hitachi.com> <alpine.LNX.2.00.1307111243420.29788@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307111243420.29788@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/11 19:51), Jiri Kosina wrote:
>>> + *	- update all but the first byte of the patched range
>>> + *	- sync cores
>>> + *	- replalace the first byte (int3) by the first byte of
>>> + *	  replacing opcode
>>> + *	- sync cores
>>> + *
>>> + * Note: must be called under text_mutex.
>>> + */
>>> +void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
>>> +{
>>> +	unsigned char int3 = 0xcc;
>>> +
>>
>> Here, you have to protect this code from others, since bp_* are
>> global.
> 
> Caller is responsible for holding the text_mutex, so text_poke_bp() can't 
> race with itself. And the proper consistency between text_poke_bp() and 
> the notifier is achieved by the memory barriers.

Oops, right. I missed your "Note" line

> 
> So what exact scenario do you have in mind here, please?

No, never mind...


Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


