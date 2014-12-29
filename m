Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaL2WNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 17:13:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37876 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaL2WNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 17:13:49 -0500
Message-ID: <54A1D211.4080609@oracle.com>
Date: Mon, 29 Dec 2014 16:13:37 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>
CC: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Remove TO DO in jfs_xtree.c
References: <549F55AC.9040308@gmail.com>
In-Reply-To: <549F55AC.9040308@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2014 06:58 PM, nick wrote:
> Greetings Dave,
> I am wondering why there is a TO DO above this code:
>         * ToDo:  tlocks should be on doubly-linked list, so we can
>         * quickly remove it and add it to the end.

I'm sure the idea was to avoid the for loop needed to find the previous
entry in the linked list. A doubly-linked list makes it much simpler to
remove an item from an arbitrary position in the list.

>         */
> 
>        /*
>        * Move parent page's tlock to the end of the tid's tlock list
>        */
>        if (log && mp->lid && (tblk->last != mp->lid) &&
>            lid_to_tlock(mp->lid)->tid) {
>                lid_t lid = mp->lid;
>                 struct tlock *prev;
> 
>              tlck = lid_to_tlock(lid);
> 
>              if (tblk->next == lid)
>                        tblk->next = tlck->next;
>              else {
>                        for (prev = lid_to_tlock(tblk->next);
>                              prev->next != lid;
>                             prev = lid_to_tlock(prev->next)) {
>                               assert(prev->next);
>                       }
>                         prev->next = tlck->next;
>               }
>               lid_to_tlock(tblk->last)->next = lid;
>               tlck->next = 0;
>                tblk->last = lid;
>        }
> As this code clearly moves the locks onto a linked list. Therefore I am recommend we remove this
> TO DO as this is clearly misleading and no longer needed.

That comment has been in the code forever and I don't have any intention
of changing things, but I don't think it's wrong. I don't mind removing
it, though. jfs has been barely maintained and there is a ton of cleanup
that can be done if someone were willing to take the time to do it.

Thanks,
Shaggy
