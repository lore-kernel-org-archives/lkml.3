Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab3GZUzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:55:32 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:49838 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab3GZUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:55:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130726201807.GJ8661@moon>
References: <20130726201807.GJ8661@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 26 Jul 2013 13:55:04 -0700
Message-ID: <CALCETrUJa-Y40vnb6YOPry0dCXb3zCQ0y19i2yHWdzKR75HUzg@mail.gmail.com>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 1:18 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Andy reported that if file page get reclaimed we loose soft-dirty bit
> if it was there, so save _PAGE_BIT_SOFT_DIRTY bit when page address
> get encoded into pte entry. Thus when #pf happens on such non-present
> pte we can restore it back.
>

Unless I'm misunderstanding this, it's saving the bit in the
non-present PTE.  This sounds wrong -- what happens if the entire pmd
(or whatever the next level is called) gets zapped?  (Also, what
happens if you unmap a file and map a different file there?)

--Andy
