Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbaLJRc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:32:27 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58501 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaLJRc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:32:26 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412101107350.6291@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141210163033.717707217@linux.com>
	<CAOJsxLFEN_w7q6NvbxkH2KTujB9auLkQgskLnGtN9iBQ4hV9sw@mail.gmail.com>
	<alpine.DEB.2.11.1412101107350.6291@gentwo.org>
Date: Wed, 10 Dec 2014 19:32:25 +0200
X-Google-Sender-Auth: 5XXepQdRU1dY6DrWmolFHcTKDB0
Message-ID: <CAOJsxLH4BGT9rGgg_4nxUMgW3sdEzLrmX2WtM8Ld3aytdR5e8g@mail.gmail.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm <akpm@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 7:08 PM, Christoph Lameter <cl@linux.com> wrote:
>> > +{
>> > +       long d = p - page->address;
>> > +
>> > +       return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
>> > +}
>>
>> Can you elaborate on what this is doing? I don't really understand it.
>
> Checks if the pointer points to the slab page. Also it tres to avoid
> having to call compound_order needlessly. Not sure if that optimization is
> worth it.

Aah, it's the (1 << MAX_ORDER) optimization that confused me. Perhaps
add a comment there to make it more obvious?

I'm fine with the optimization:

Reviewed-by: Pekka Enberg <penberg@kernel.org>

- Pekka
