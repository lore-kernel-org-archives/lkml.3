Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3HEUGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:06:51 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:43826 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305Ab3HEUGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:06:50 -0400
Message-ID: <520005D8.9080108@akamai.com>
Date: Mon, 05 Aug 2013 16:06:48 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home>  <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>  <1375725328.22073.101.camel@gandalf.local.home>  <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com> <1375727977.22073.112.camel@gandalf.local.home>
In-Reply-To: <1375727977.22073.112.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 02:39 PM, Steven Rostedt wrote:
> On Mon, 2013-08-05 at 11:20 -0700, Linus Torvalds wrote:
>
>> Of course, it would be good to optimize static_key_false() itself -
>> right now those static key jumps are always five bytes, and while they
>> get nopped out, it would still be nice if there was some way to have
>> just a two-byte nop (turning into a short branch) *if* we can reach
>> another jump that way..For small functions that would be lovely. Oh
>> well.
> I had patches that did exactly this:
>
>   https://lkml.org/lkml/2012/3/8/461
>
> But it got dropped for some reason. I don't remember why. Maybe because
> of the complexity?
>
> -- Steve

Hi Steve,

I recall testing your patches and the text size increased unexpectedly. 
I believe I correctly accounted for changes to the text size *outside* 
of branch points. If you do re-visit the series that is one thing I'd 
like to double check/understand.

Thanks,

-Jason
