Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3GXSwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:52:33 -0400
Received: from relay.parallels.com ([195.214.232.42]:60702 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3GXSwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:52:32 -0400
Message-ID: <51F0225A.8040705@parallels.com>
Date: Wed, 24 Jul 2013 22:52:10 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
References: <20130724160826.GD24851@moon> <CALCETrXYnkonpBANnUuX+aJ=B=EYFwecZO27yrqcEU8WErz9DA@mail.gmail.com>
In-Reply-To: <CALCETrXYnkonpBANnUuX+aJ=B=EYFwecZO27yrqcEU8WErz9DA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 08:23 PM, Andy Lutomirski wrote:
> On Wed, Jul 24, 2013 at 9:08 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> Andy Lutomirski reported that in case if a page with _PAGE_SOFT_DIRTY
>> bit set get swapped out, the bit is getting lost and no longer
>> available when pte read back.
> 
> Potentially silly question (due to my completely lack of understanding
> of how swapping works in Linux): what about file-backed pages?

Strictly speaking file-backed mappings should also be fixed to keep the
soft-dirty bit, yes.

But in checkpoint-restore _shared_ file mappings are not of interest, as
all the data (changed or not) sits in the file and we just don't need to
take it into dump. If the file mapping of _private_, then pages, that are
written to become anonymous and occur in the swap cache and are handled
by this patch.

> (Arguably these would be best supported by filesystems instead of by
> the core vm, in which case it might make sense to drop soft-dirty
> support for these pages entirely.)
> 
> --Andy
> .
> 


