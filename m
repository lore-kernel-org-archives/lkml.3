Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbbAUUXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:23:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbbAUUXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:23:45 -0500
Message-ID: <54C00A7B.1000808@zytor.com>
Date: Wed, 21 Jan 2015 12:22:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: jsrhbz@kanargh.force9.co.uk, christoph.muellner@theobroma-systems.com,
        linux@roeck-us.net, linux@rasmusvillemoes.dk,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, mingo@kernel.org,
        akpm@linux-foundation.org, maxime.coquelin@st.com,
        linux-kernel@vger.kernel.org, martink@posteo.de, tytso@mit.edu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/types] bitops: Add sign_extend8(), 16 and 64 functions
References: <1421083370-24924-1-git-send-email-martink@posteo.de> <tip-7e9358073d3f0ed0a028c48aa54009b3296dffc9@git.kernel.org> <CA+55aFyc7TbnLBi3rcQDrtkwg9TgDnb5dAfupMGSbTKZC6Xd0g@mail.gmail.com> <20150119100439.GN25256@twins.programming.kicks-ass.net>
In-Reply-To: <20150119100439.GN25256@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 02:04 AM, Peter Zijlstra wrote:
> On Mon, Jan 19, 2015 at 07:54:22AM +1200, Linus Torvalds wrote:
>> Why?
>>
>> The 8- and 16- bit versions are the same as the 32-bit one. This seems
>> pointless. If you want something where the sign is in bit 3, they all
>> return the same value, just the return type differs, but that's really a
>> *caller* thing, no?
> 
> Even for the 8bit ones? Since we have the *H and *L register we have
> more 8 bit regs than we have 16/32 bit regs and it might just be worth
> it.

Fewer, actually.  gcc doesn't really use the H registers much, and
instead considers 8-bit values to occupy the whole register, but that
means only four are available in 32-bit mode.

	-hpa

