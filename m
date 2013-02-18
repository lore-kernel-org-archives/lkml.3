Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3BRSJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:09:21 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53869 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab3BRSJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:09:20 -0500
Message-ID: <51226E0B.5080000@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 12:08:11 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Mason <ric.masonn@gmail.com>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH v2] zsmalloc: Add Kconfig for enabling PTE method
References: <1360117028-5625-1-git-send-email-minchan@kernel.org> <51207655.5000209@gmail.com>
In-Reply-To: <51207655.5000209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021818-2398-0000-0000-0000112E82B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 12:19 AM, Ric Mason wrote:
> On 02/06/2013 10:17 AM, Minchan Kim wrote:
>> Zsmalloc has two methods 1) copy-based and 2) pte-based to access
>> allocations that span two pages. You can see history why we supported
>> two approach from [1].
>>
>> In summary, copy-based method is 3 times fater in x86 while pte-based
>> is 6 times faster in ARM.
> 
> Why in some arches copy-based method is better and in the other arches
> pte-based is better? What's the root reason?

Minchan might know more about this (or Russell King) but I'll give it
a try.

MMU designs can vary pretty significantly from arch to arch.  An
operation that is cheap on one MMU design can be expensive on another,
especially once SMP gets involved, possibly resulting in
inter-processor interrupts.

RAM speed is also a factor since the copy-method will use more memory
bandwidth.  Embedded systems typically won't have really fast memory.

Seth

