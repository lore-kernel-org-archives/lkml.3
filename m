Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab3BTOYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:24:08 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41835 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800Ab3BTOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:24:04 -0500
MIME-Version: 1.0
In-Reply-To: <1359699013-7160-1-git-send-email-hannes@cmpxchg.org>
References: <1359699013-7160-1-git-send-email-hannes@cmpxchg.org>
Date: Wed, 20 Feb 2013 22:24:02 +0800
Message-ID: <CANN689Hwp-fm-SUzAXAqLKGkGHxjw2X+pkQRr01=Fjq=BaSoDQ@mail.gmail.com>
Subject: Re: [patch] mm: mlock: document scary-looking stack expansion mlock chain
From: Michel Lespinasse <walken@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 2:10 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> The fact that mlock calls get_user_pages, and get_user_pages might
> call mlock when expanding a stack looks like a potential recursion.
>
> However, mlock makes sure the requested range is already contained
> within a vma, so no stack expansion will actually happen from mlock.
>
> Should this ever change: the stack expansion mlocks only the newly
> expanded range and so will not result in recursive expansion.
>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
