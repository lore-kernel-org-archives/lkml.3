Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaBYTpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:45:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59179 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaBYTpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:45:46 -0500
Message-ID: <530CF21E.1020603@zytor.com>
Date: Tue, 25 Feb 2014 11:42:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Dave Young <dyoung@redhat.com>, Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v4 0/6] generic early_ioremap support
References: <1392238575-10000-1-git-send-email-msalter@redhat.com>	 <1393337404.7307.51.camel@deneb.redhat.com>	 <20140225183012.GA27164@mudshark.cambridge.arm.com> <1393353942.26583.10.camel@deneb.redhat.com>
In-Reply-To: <1393353942.26583.10.camel@deneb.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 10:45 AM, Mark Salter wrote:
> On Tue, 2014-02-25 at 18:30 +0000, Will Deacon wrote:
>> I'd suggest spitting the core part out from the arch-specific parts. That
>> way, the core part can merged independently and architectures can move over
>> as they see fit. It also signals (at least to me) that, "hey, I should
>> probably review this" whilst my current stance is "there's a whole load of
>> stuff under mm/ that needs to be acked first".
>>
>> If you put the whole thing into next, you just run the risk of conflicts
>> with all the arch trees.
> 
> I've been thinking of breaking out the common bits and x86 bits and just
> going with that for now. There's no point in just doing the common bits
> because it won't get tested without at least one architecture using it.
> 

If you think it makes sense we could take the common bits + x86 and put
them through the -tip tree.  The other option would be to put the whole
thread in linux-next with Acks.

As far as x86 is concerned it looks like it is mostly just code
movement, so I'm happy giving my:

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

