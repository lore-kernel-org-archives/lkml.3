Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3GIHsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:48:21 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:43873 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIHsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:48:20 -0400
Message-ID: <51DBC021.5040805@synopsys.com>
Date: Tue, 9 Jul 2013 13:17:45 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Wedson Almeida Filho <wedsonaf@gmail.com>
CC: Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Tim Abbott" <tabbott@ksplice.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: One less subtraction in binary search iterations.
References: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com> <1373173169.1943.1.camel@joe-AO722> <CANeycqqGYKs+Q+_6zpjfdQ+y-QBZLD+jGdU9-YJi9XaYXyCv-w@mail.gmail.com>
In-Reply-To: <CANeycqqGYKs+Q+_6zpjfdQ+y-QBZLD+jGdU9-YJi9XaYXyCv-w@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 09:21 AM, Wedson Almeida Filho wrote:
> On Sat, Jul 6, 2013 at 9:59 PM, Joe Perches <joe@perches.com> wrote:
>>
>> Not correct.
>>
>>>       while (start < end) {
>>> -             size_t mid = start + (end - start) / 2;
>>> +             size_t mid = (start + end) / 2;
>>
>>         size_t start = 0x80000000;
>>         size_t end   = 0x80000001;
> 
> Good point, they aren't equivalent in all cases.
> 
> For the overflow to happen though, we need an array with at least
> N/2+1 entries, where N is the address space size. The array wouldn't
> fit in addressable memory if the element size is greater than 1, so
> this can only really happen when the element size is 1. Even then, it
> would require the kernel range to be greater than half of all
> addressable memory, and allow an allocation taking that much memory. I
> don't know all architectures where linux runs, but I don't think such
> configuration is likely to exist.
> 

It does. In ARC port (arch/arc), the untranslated address space starts at
0x8000_0000 and this is where kernel is linked at. So all ARC kernel addresses
(code/data) lie in that range. This means you don't need special corner case for
this trip on ARC - it will break rightaway - unless I'm missing something.

P.S. Sorry for not replying earlier than ur v2.

-Vineet
