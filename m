Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaCRAgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:36:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCRAgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:36:13 -0400
Date: Tue, 18 Mar 2014 00:37:25 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
Message-ID: <20140318003725.GA12217@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
 <20140317214145.GA29105@kroah.com>
 <CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 09:26:07AM +0900, DaeSeok Youn wrote:
> I think vmalloc/kmalloc in uislib_malloc() can be removed and just use
> vmalloc/kmalloc directly.

Yes.  Actually, just use kmalloc, I don't knwo why vmalloc is being
used, but cc: the driver maintainers just to be sure.

> (UISMALLOC() macro is also removed.)

Yes.

> And uislib_malloc() is renamed to "uislib_trace_buffer_status()" which
> is just tracing buffer status(Malloc_FailuresAlloc, Malloc_BytesInUse
> ...) for info_proc_read_helper().

The whole tracing stuff needs to be ripped out, so no problem deleting
it here as well.

> If this change is accepted, it also need to change uislib_free().

Drop it and just use kfree().

thanks,

greg k-h
