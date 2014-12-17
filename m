Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaLQHPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:15:36 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:52763 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLQHPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:15:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412160948240.27999@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141210163033.717707217@linux.com>
	<20141215080338.GE4898@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1412150815210.20101@gentwo.org>
	<20141216024210.GB23270@js1304-P5Q-DELUXE>
	<CAPAsAGyGXSP-2eY1CQS1jDpJq89kwpCuJm4ZBa3cYDGkv_oTxA@mail.gmail.com>
	<20141216082555.GA6088@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1412160852460.27498@gentwo.org>
	<20141216161521.1f72e102@redhat.com>
	<alpine.DEB.2.11.1412160948240.27999@gentwo.org>
Date: Wed, 17 Dec 2014 16:15:34 +0900
Message-ID: <CAAmzW4MaGCCq4_pz+9dFDY+0X+3qcfr4aTSPsjt8ejkV9WbMnA@mail.gmail.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
From: Joonsoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-17 0:48 GMT+09:00 Christoph Lameter <cl@linux.com>:
> On Tue, 16 Dec 2014, Jesper Dangaard Brouer wrote:
>
>> > Ok but now there is a multiplication in the fast path.
>>
>> Could we pre-calculate the value (page->objects * s->size) and e.g store it
>> in struct kmem_cache, thus saving the imul ?
>
> I think I just used the last available field for the page->address.

Possibly, we can use _count field.

Thanks.
