Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935299Ab3BTOXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:23:00 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:40245 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322Ab3BTOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:22:58 -0500
MIME-Version: 1.0
In-Reply-To: <5124C6CF.1020001@gmail.com>
References: <1359699013-7160-1-git-send-email-hannes@cmpxchg.org>
	<5124C6CF.1020001@gmail.com>
Date: Wed, 20 Feb 2013 22:22:58 +0800
Message-ID: <CANN689FizixMWu7hKMV055=SY_Sg1rmYrB_KAEwOBP1tEOZw+Q@mail.gmail.com>
Subject: Re: [patch] mm: mlock: document scary-looking stack expansion mlock chain
From: Michel Lespinasse <walken@google.com>
To: Ric Mason <ric.masonn@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 8:51 PM, Ric Mason <ric.masonn@gmail.com> wrote:
> On 02/01/2013 02:10 PM, Johannes Weiner wrote:
>>
>> The fact that mlock calls get_user_pages, and get_user_pages might
>> call mlock when expanding a stack looks like a potential recursion.
>
> Why expand stack need call mlock? I can't find it in the codes, could you
> point out to me?

Its hidden in find_expand_vma(). Basically if the existing stack is
already mlocked, any additional stack expansions get mlocked as well.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
