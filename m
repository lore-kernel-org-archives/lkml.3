Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLPPdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:33:17 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59603 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaLPPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:33:15 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412160852460.27498@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141210163033.717707217@linux.com>
	<20141215080338.GE4898@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1412150815210.20101@gentwo.org>
	<20141216024210.GB23270@js1304-P5Q-DELUXE>
	<CAPAsAGyGXSP-2eY1CQS1jDpJq89kwpCuJm4ZBa3cYDGkv_oTxA@mail.gmail.com>
	<20141216082555.GA6088@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1412160852460.27498@gentwo.org>
Date: Tue, 16 Dec 2014 19:33:15 +0400
Message-ID: <CAPAsAGxVaucq5yOWiMztL4MGwpKGbC=WuhWFagXQ0UtWtPoqbw@mail.gmail.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-16 17:53 GMT+03:00 Christoph Lameter <cl@linux.com>:
> On Tue, 16 Dec 2014, Joonsoo Kim wrote:
>
>> > Like this:
>> >
>> >         return d > 0 && d < page->objects * s->size;
>> >
>>
>> Yes! That's what I'm looking for.
>> Christoph, how about above change?
>
> Ok but now there is a multiplication in the fast path.
>

Another idea - store page's order in the lower bits of page->address.
