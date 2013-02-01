Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3BAQ4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:56:20 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:54235 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3BAQ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:56:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130201163455.GB4908@localhost>
References: <20130201130207.444989281@linuxfoundation.org>
	<20130201130213.388508268@linuxfoundation.org>
	<CA+6hz4qjj3wGgo-m50=qRxAN+OGUXKfUfgRp7Pys7NixgwQ3vQ@mail.gmail.com>
	<20130201163455.GB4908@localhost>
Date: Sat, 2 Feb 2013 00:56:17 +0800
Message-ID: <CA+6hz4rbzeDtYx9-sMDdgt2QxpcpGLrEBwezaEush1gb_W-o4w@mail.gmail.com>
Subject: Re: [ 82/89] netfilter: xt_hashlimit: fix race that results in
 duplicated entries
From: Feng Gao <gfree.wind@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Pablo.

I have a question about commiting the patch for kernel.

Because i am the reporter of this issue, and I sent the similar fix to
netfilter maillist and the owner of the xt_hashlimit.c before.
Now it is that Greg commits the patch for this issue, not me, although
the fix is similar with that I sent before.
I am just a little disappointed, not explain.
Because I would be very prond of as the contributor who could commit
patch to linux.

So I wonder How could I commit the patch to kernel directly or how to
let owner could adopt my fix directly next time?

BTW, I still be prond as this issue reporter.

Best regards.
Feng Gao


On Sat, Feb 2, 2013 at 12:34 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Feb 01, 2013 at 11:04:36PM +0800, Feng Gao wrote:
>>    Hi Greg,
>>    I have a question.
>>    There are two duplicated lines now.
>>                           dh->expires = now +
>>    msecs_to_jiffies(hinfo->cfg.expire);
>>                           rateinfo_recalc(dh, now, hinfo->cfg.mode);
>>    1# case: The dsthash_find return a valid dh;
>>    2# case: There is a race. The race is true.
>>    Why we could not adopt the method I sent before.
>>        dh = dsthash_find(hinfo, &dst);
>>        if (dh == NULL) {
>>            dh = dsthash_alloc_init(hinfo, &dst, &new_node);
>>            if (dh == NULL) {
>>                rcu_read_unlock_bh();
>>                goto hotdrop;
>>            }
>>        }
>>        if (new_node) {
>>            dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
>>            rateinfo_init(dh, hinfo);
>>        } else {
>>            /* update expiration timeout */
>>            dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
>>            rateinfo_recalc(dh, now, hinfo->cfg.mode);
>>        }
>>    I think it could avoid the two duplicated lines.
>
> That's a cleanup, send me a follow up patch for that if you want.
>
> Greg, please, don't back down this patch, it's fixing a real problem.
>
> Gao is proposing some code refactoring to save line a couple of lines
> of code.
