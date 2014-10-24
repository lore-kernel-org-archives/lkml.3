Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaJXTrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:47:51 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50153 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbaJXTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <20141024.133249.71272218161411159.davem@davemloft.net>
References: <20141024.133249.71272218161411159.davem@davemloft.net>
Date: Fri, 24 Oct 2014 12:47:48 -0700
X-Google-Sender-Auth: k68UQhSzrTzihoKydpKmgP4Ov-w
Message-ID: <CA+55aFyqtuh53PmwO65NtM_PrPd51=EMWiv8dU8bNTrXL59=Jg@mail.gmail.com>
Subject: Re: [GIT] Sparc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, sparclinux@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:32 AM, David Miller <davem@davemloft.net> wrote:
>
>    It's really idiotic to have a weak symbolled fallback that just
>    returns zero, and causes this kind of bug.  There should be no
>    backup implementation and the link should fail if the architecture
>    fails to provide __get_user_pages_fast() and supports transparent
>    hugepages.

Agreed. I think the weak fallback is for the "no hugepages support"
case, but that does sound very annoying and fragile.

                   Linus
