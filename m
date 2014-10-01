Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaJASOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:14:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42632 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbaJASOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:14:16 -0400
Message-ID: <542C4463.1020208@zytor.com>
Date: Wed, 01 Oct 2014 11:13:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86, kaslr: avoid setup_data when picking location
References: <20140911161931.GA12001@www.outflux.net>	<542C4177.6060409@zytor.com> <CAGXu5jLK-k4JZO4eZSasRuSSQxeru94U9whMPcgD6iin40VVTA@mail.gmail.com>
In-Reply-To: <CAGXu5jLK-k4JZO4eZSasRuSSQxeru94U9whMPcgD6iin40VVTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 11:08 AM, Kees Cook wrote:
>>
>> The use of (u64) in the assignment to avoid.start gives a nuisance
>> warning on 32 bits.
> 
> Ah, good catch! This should be (unsigned long), I think. Shall I send
> a follow-up patch, or do you want to fix this directly?
> 

Please do.

In theory it is possible for a bootloader to put an object above 4G even
for a 32-bit kernel, but that is likely to break any kind of other
things, so I'm not worried about it.  You don't need to worry about
avoiding such a zone, the problem is mostly that you can't follow the
list any further without adding PAE-handling code.

	-hpa


