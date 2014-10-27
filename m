Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaJ0U3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:29:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:27269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaJ0U3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,797,1406617200"; 
   d="scan'208";a="597180111"
Message-ID: <544EAB1A.2030403@linux.intel.com>
Date: Mon, 27 Oct 2014 13:29:14 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, Darren Hart <dvhart@infradead.org>
Subject: Re: futex testsuite suggestion...
References: <20141027.155656.1414383076601514662.davem@davemloft.net>
In-Reply-To: <20141027.155656.1414383076601514662.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/14 12:56, David Miller wrote:
> 
> First of all, thanks so much for writing your futex test suite, it's
> proved invaluable for sparc64 kernel development for me lately.

Hi David,

Glad to hear it :-)

> 
> I'd like to suggest that you add a test that triggers transparent
> hugepages, because if an architecture doesn't implement
> __get_user_pages_fast() such futexes cause a machine to hang.
> 
> I hacked up something simple that took the existing performance
> test and made it operate in a register allocated using memalign().
> 
> I would suggest doing a memalign(HUGEPAGE_SIZE, HUGEPAGE_SIZE) then
> iterating running a futex test within each normal page within that
> hugepage.

Do you want this option for the performance tests, or would a less
intensive functional test be sufficient?

The other thing to note is there have been several efforts/false starts
to get futextests into perf and kselftest. We currently considering
splitting futextests across the two (performance to perf, functional to
kselftest). The TODO for a fuzz tester is handled *more* than adequately
by trinity.

I'm perfectly happy to add such a test. I'm currently buried under a
number of other things that have resulted in futextests suffering
somewhat. So a couple of things to help make this happen:

1) Could you send me your hacked up test, in whatever condition?
2) I'm more than happy to accept patches, but I do understand why you
might prefer to have someone else write it :-)

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
