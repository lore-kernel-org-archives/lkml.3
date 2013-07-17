Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3GQJxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:53:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16139 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3GQJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:53:21 -0400
Message-ID: <51E6673F.5050002@huawei.com>
Date: Wed, 17 Jul 2013 17:43:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Steven Rostedt <rostedt@goodmis.org>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
References: <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu> <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz> <s5hwqoqv4oo.wl%tiwai@suse.de> <20130716165933.GU22506@sirena.org.uk> <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com> <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com> <1374000084.6458.36.camel@gandalf.local.home> <20130716191147.GA1680@kroah.com> <1374003789.6458.55.camel@gandalf.local.home> <20130716201041.GC20721@1wt.eu>
In-Reply-To: <20130716201041.GC20721@1wt.eu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/17 4:10, Willy Tarreau wrote:
> On Tue, Jul 16, 2013 at 03:43:09PM -0400, Steven Rostedt wrote:
>> On Tue, 2013-07-16 at 12:11 -0700, Greg Kroah-Hartman wrote:
>>
>>> People mark stable patches that way already today with a:
>>> 	Cc: stable <stable@vger.kernel.org> # delay for 3.12-rc4
>>> or some such wording.  I take those and don't apply them until the noted
>>> release happens, so you can do this if needed.

But this is not documented in stable_kernel_rules.txt. And it's not handled
by your automatic scripts?

>>
>> I guess the thing is, are stable patches prone to regressions. Do we
>> just do that for patches that we think are too complex and may cause
>> some harm. Of course, there's the question about having a clue about
>> what patches might cause harm or not.
> 
> We'd probably better switch the tag to be "# now" to imply that we don't
> want to delay them, and that by default those merged prior to rc4 are all
> postponed. I suspect that the switching could be mostly automated this way,
> avoiding to add burden to Greg :
> 
>   - if commit ID >= -rc4
>     move to immediate queue, it's a "critical" fix as per Linus' rules
> 
>   - if Cc: stable line has "now" at the end, move to immediate queue as
>     the maintainer takes this reponsibility ;
> 
>   - otherwise move to the next .2 queue.
> 

I like the idea of postpone stable patches by default.

