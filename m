Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaLJQ7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:59:14 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59656 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbaLJQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:59:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141210163033.970247616@linux.com>
References: <20141210163017.092096069@linux.com>
	<20141210163033.970247616@linux.com>
Date: Wed, 10 Dec 2014 18:59:11 +0200
X-Google-Sender-Auth: A02SwF4wNIRxGtXPWT-X5wuNEFY
Message-ID: <CAOJsxLFEMDwqGtSOBG-6Yjfk7NEzK9pQeTeGuzZFQ=F4Pqmx0Q@mail.gmail.com>
Subject: Re: [PATCH 5/7] slub: Use end_token instead of NULL to terminate freelists
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

On Wed, Dec 10, 2014 at 6:30 PM, Christoph Lameter <cl@linux.com> wrote:
> Ending a list with NULL means that the termination of a list is the same
> for all slab pages. The pointers of freelists otherwise always are
> pointing to the address space of the page. Make termination of a
> list possible by setting the lowest bit in the freelist address
> and use the start address of a page if no other address is available
> for list termination.
>
> This will allow us to determine the page struct address from a
> freelist pointer in the future.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
