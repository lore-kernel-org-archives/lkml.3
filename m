Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaAVSjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:39:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaAVSjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:39:41 -0500
Message-ID: <52E01064.9090905@redhat.com>
Date: Wed, 22 Jan 2014 13:39:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Steven Noonan <steven@uplinklabs.net>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
References: <20140121232708.GA29787@amazon.com>	<20140122014908.GG18164@kroah.com>	<CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>	<52E008F0.3060602@redhat.com> <CA+55aFypCEec_15J-bPAuc1G=GtnQXjnnW5+dzwODq2DNW4Bsg@mail.gmail.com>
In-Reply-To: <CA+55aFypCEec_15J-bPAuc1G=GtnQXjnnW5+dzwODq2DNW4Bsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 01:24 PM, Linus Torvalds wrote:
> On Wed, Jan 22, 2014 at 10:07 AM, Rik van Riel <riel@redhat.com> wrote:
>>
>> The difference between a numa pte and a protnone pte is
>> the VMA permissions.
>
> If that is indeed the only difference, then we should damn well get
> rid of that f*cking stupid _PAGE_NUMA name entirely.
>
> It's misleading crap. Really. Just do a quick grep for that bit, and
> you see just *how* confused people are about it:
>
>     #define _PAGE_NUMA _PAGE_PROTNONE
>     ...
>          if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &
>
> think about it. Just *THINK* about how broken that code is. The whole
> thing is a disaster. _PAGE_NUMA must die. It's shit.

The reason things are this way is that we were
not sure whether we can indeed use _PAGE_PROTNONE
for NUMA balancing on all architectures.

If we are sure that _PAGE_PROTNONE can be used
everywhere, I agree we should get rid of the whole
_PAGE_NUMA naming, and replace that ambiguous
code with some comments and documentation instead.

