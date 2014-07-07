Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaGGWuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:50:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59947 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGGWuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:50:18 -0400
Message-ID: <53BB240C.30400@zytor.com>
Date: Mon, 07 Jul 2014 15:49:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: fallout of 16K stacks
References: <20140707223001.GD18735@two.firstfloor.org>
In-Reply-To: <20140707223001.GD18735@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 03:30 PM, Andi Kleen wrote:
> 
> Since the 16K stack change I noticed a number of problems with
> my usual stress tests. They have a tendency to bomb out
> because something cannot fork.

As in ENOMEM or does something worse happen?

> - AIM7 on a dual socket socket system now cannot reliably run 
>> 1000 parallel jobs.

... with how much RAM?

> - LTP stress + memhog stress in parallel to something else
> usually doesn't survive the night.
> 
> Do we need to strengthen the memory allocator to try
> harder for 16K?

Can we even?  The probability of success goes down exponentially in the
order requested.  Movable pages can help, of course, but still, there is
a very real cost to this :(

	-hpa

