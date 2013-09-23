Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3IWUSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:18:23 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:44229 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3IWUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:18:21 -0400
Message-ID: <5240A209.3060202@converseincode.com>
Date: Mon, 23 Sep 2013 15:18:17 -0500
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] usb: gadget LLVMLinux: Removing the use of VLAIS from
 the gadget driver
References: <1375407344-30120-1-git-send-email-behanw@converseincode.com>	<52291CAF.1000504@converseincode.com>	<20130923193030.GM30811@radagast> <CA+55aFy6h1c3_rP_bXFedsTXzwW+9Q9MfJaW7GUmMBrAp-fJ9A@mail.gmail.com>
In-Reply-To: <CA+55aFy6h1c3_rP_bXFedsTXzwW+9Q9MfJaW7GUmMBrAp-fJ9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/13 15:08, Linus Torvalds wrote:
> On Mon, Sep 23, 2013 at 12:30 PM, Felipe Balbi <balbi@ti.com> wrote:
>> I remember there was a discussion of not dropping variable length array
>> support, wasn't there ?
> We should definitely drop it. The feature is an abomination. I thought
> gcc only allowed them at the end of structs, in the middle of a struct
> it's just f*cking insane beyond belief.
>
> That said, for *this* particular case, that USB widget driver already
> does a ton of small kmalloc's and then remembers the addresses
> independently. People may not care about performance, but it *might*
> be a good idea to just do one kmalloc()/kfree(), and then still have
> those pointer variables, but just be offsets within that one
> allocation.
>
> That's what gcc has to basically do for that thing internally
> *anyway*, just hidden behind a horrible construct that should never
> have existed.
We can certainly do that instead.

I believe I already have a version of the patch which does just that 
(without using macros). I will post it for comment.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

