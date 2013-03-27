Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3C0N3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:29:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab3C0N3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:29:49 -0400
Message-ID: <5152F44B.2000901@suse.cz>
Date: Wed, 27 Mar 2013 14:29:47 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/tags.sh: Add magic for OFFSET and DEFINE
References: <1810321364036300@web2f.yandex.ru> <20130326213532.GB22359@pobox.suse.cz> <1897121364385591@web7g.yandex.ru>
In-Reply-To: <1897121364385591@web7g.yandex.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.3.2013 12:59, Kirill Tkhai wrote:
> 27.03.2013, 01:35, "Michal Marek" <mmarek@suse.cz>:
>> The macro definitions in the asm-offsets.h file are ammended with a
>> comment explaining what the value actually means. So you see both the
>> value and the semantic of the macro:
>>
>> #define TI_flags 16 /* offsetof(struct thread_info, flags)      # */
>>
>> By jumping to the asm-offset.c file instead, you would get only a subset
>> of that information.
>>
>> OFFSET(TI_flags, thread_info, flags);
>>
>> Unless I'm missing something, I don't think that this patch improves
>> much.
> 
> This patch does not annul definitions in asm-offsets.h. They stay still on their places.
> It adds OFFSETs and DEFINEs from asm-offsets.c files.
> 
> When kernel is not precompiled you do not have asm-offsets.h and you are not
> able to see what is the place offsets are defined for yor architecture.
> 
> Also, you are not able to look at other architectures because they do not have
> precompiled asm-offsets.h.

I see, these are valid use cases for the regexps. I applied your patch
to kbuild.git#misc now.

Michal
