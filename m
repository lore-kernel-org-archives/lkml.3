Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3HZUqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:46:09 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:42570 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3HZUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw_bhMOP73owFHRFHZDAYEdWgF9j-502Aq9tZe3tEfmwg@mail.gmail.com>
References: <20130807153030.GA25515@redhat.com>
	<CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
	<20130819231836.GD14369@redhat.com>
	<CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
	<20130821204901.GA19802@redhat.com>
	<CAJd=RBBNCf5_V-nHjK0gOqS4OLMszgB7Rg_WMf4DvL-De+ZdHA@mail.gmail.com>
	<20130823032127.GA5098@redhat.com>
	<CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
	<20130823035344.GB5098@redhat.com>
	<CAJd=RBBtY-nJfo9nzG5gtgcvB2bz+sxpK5kX33o1sLeLhvEU1Q@mail.gmail.com>
	<20130826190757.GB27768@redhat.com>
	<CA+55aFw_bhMOP73owFHRFHZDAYEdWgF9j-502Aq9tZe3tEfmwg@mail.gmail.com>
Date: Mon, 26 Aug 2013 13:46:05 -0700
X-Google-Sender-Auth: JAf6p1CKR6pN3qVNZrG9RFvRmRE
Message-ID: <CA+55aFwQbJbR3xij1+iGbvj3EQggF9NLGAfDbmA54FkKz9xfew@mail.gmail.com>
Subject: Re: unused swap offset / bad page map.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 1:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'm almost likely to think that we are more likely to have
> something wrong in the messy magical special cases.

Of course, the good news would be if it actually ends up being the
soft-dirty stuff, and bisection hits something recent.

So maybe I'm overly pessimistic. That messy swap_map[] code really
_is_ messy, but at the same time it should also be pretty well-tested.
I don't think it's been touched in years.

That said, google does find "swap_free: Unused swap offset entry"
reports from over the years. Most of them seem to be single-bit
errors, though (ie when the entry is 00000100 or similar I'm more
inclined to blame a bit error - in contrast your values look like
"real" swap entries).

            Linus
