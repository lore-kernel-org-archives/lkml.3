Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbaFIQwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:52:50 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45610 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395AbaFIQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:52:47 -0400
Date: Mon, 9 Jun 2014 18:52:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/9] perf, tools: Add support for text descriptions of
 events and alias add
Message-ID: <20140609165245.GR25366@two.firstfloor.org>
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
 <1401486615-21374-3-git-send-email-andi@firstfloor.org>
 <87ha3ud6ic.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha3ud6ic.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm.. this will print the description at right side and I think it'd be
> better if it prints in another line(s) like below:

I think it's better to show the descriptions by default without 
an extra option. I suspect most people want to see them, or if they
need them they won't know about obscure -v options.

> 
>   agu_bypass_cancel.count                            [Kernel PMU event]
>         This event counts executed load operations with all the following
>          traits: 1. addressing of the format [base + offset], 2. the offset
>          is between 1 and 2047, 3. the address specified in the base register
>          is in one page and the address [base+offset] is in an

The problem with this format is that it is not compatible, so it would
break existing parsers that look at perf list output.  That is why I ended up
with the right side format.


>   arith.fpu_div                                      [Kernel PMU event]
>         Divide operations executed
>   arith.fpu_div_active                               [Kernel PMU event]
>         Cycles when divider is busy executing divide operations
>   ...
> 
> 
> I just tweaked it using -v option for perf list.  Below is the change I
> made on top of your series.  What do you think?

I prefer not to apply that patch.

I guess what could make sense is a quiet option to not print
descriptions.

-Andi
