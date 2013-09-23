Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3IWUIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:08:53 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60251 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IWUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130923193030.GM30811@radagast>
References: <1375407344-30120-1-git-send-email-behanw@converseincode.com>
	<52291CAF.1000504@converseincode.com>
	<20130923193030.GM30811@radagast>
Date: Mon, 23 Sep 2013 13:08:50 -0700
X-Google-Sender-Auth: AGpEEikma1esGMV2jj601HS6zeM
Message-ID: <CA+55aFy6h1c3_rP_bXFedsTXzwW+9Q9MfJaW7GUmMBrAp-fJ9A@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget LLVMLinux: Removing the use of VLAIS from the
 gadget driver
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Behan Webster <behanw@converseincode.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Charlebois <charlebm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:30 PM, Felipe Balbi <balbi@ti.com> wrote:
>
> I remember there was a discussion of not dropping variable length array
> support, wasn't there ?

We should definitely drop it. The feature is an abomination. I thought
gcc only allowed them at the end of structs, in the middle of a struct
it's just f*cking insane beyond belief.

That said, for *this* particular case, that USB widget driver already
does a ton of small kmalloc's and then remembers the addresses
independently. People may not care about performance, but it *might*
be a good idea to just do one kmalloc()/kfree(), and then still have
those pointer variables, but just be offsets within that one
allocation.

That's what gcc has to basically do for that thing internally
*anyway*, just hidden behind a horrible construct that should never
have existed.

              Linus
