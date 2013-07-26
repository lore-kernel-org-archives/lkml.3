Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab3GZX3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:29:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41587 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab3GZX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:28:59 -0400
X-Sasl-enc: FN7FqJG1OyqLj2a9ulF0iXLb3DkbBbftLgZE/zpG5NnH 1374881337
Date: Fri, 26 Jul 2013 16:28:55 -0700
From: Greg KH <greg@kroah.com>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20130726232855.GA2492@kroah.com>
References: <20130726160254.83bbe994219d6ee732c64b7d@canb.auug.org.au>
 <20130726210335.GA2788@kroah.com>
 <51F2E8A4.2010405@gmail.com>
 <20130726215634.GA31820@kroah.com>
 <51F2FE34.8010601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F2FE34.8010601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 01:54:44AM +0300, Eli Billauer wrote:
> On 27/07/13 00:56, Greg KH wrote:
> >No, I need you to do that.  Can you do a kernel build with:
> >	make M=drivers/staging/xillybus C=1
> >and fix up the errors that sparse reports and send a patch for that?
> >
> I'm not sure it's related to me. I get the same errors whether I
> compile my own modules or something in e.g. drivers/tty/ . This is
> what I get after make allmodconfig on the current staging git repo:
> 
> $ make M=drivers/staging/xillybus C=1
> /home/eli/xillybus/submission/staging/arch/x86/Makefile:107:
> CONFIG_X86_X32 enabled but no binutils support
>   CHECK   drivers/staging/xillybus/xillybus_core.c
> /home/eli/xillybus/submission/staging/arch/x86/include/asm/jump_label.h:16:13:
> error: Expected ( after asm
> /home/eli/xillybus/submission/staging/arch/x86/include/asm/jump_label.h:16:13:
> error: got goto
>   CC [M]  drivers/staging/xillybus/xillybus_core.o
>   CHECK   drivers/staging/xillybus/xillybus_pcie.c
> /home/eli/xillybus/submission/staging/arch/x86/include/asm/jump_label.h:16:13:
> error: Expected ( after asm
> /home/eli/xillybus/submission/staging/arch/x86/include/asm/jump_label.h:16:13:
> error: got goto
>   CC [M]  drivers/staging/xillybus/xillybus_pcie.o
> 
> I'll spare you the output from modules in drivers/tty. But it's
> exactly the same messages on each of these modules.
> 
> Am I doing something wrong?

Odd, you might need to upgrade the version of sparse you have.  My
output looks like:

$ make M=drivers/staging/xillybus/ C=1
  LD      drivers/staging/xillybus//built-in.o
  CHECK   drivers/staging/xillybus//xillybus_core.c
drivers/staging/xillybus//xillybus_core.c:76:25: warning: symbol 'xillybus_wq' was not declared. Should it be static?
drivers/staging/xillybus//xillybus_core.c:175:57: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/xillybus//xillybus_core.c:175:57:    expected void [noderef] <asn:2>*<noident>
drivers/staging/xillybus//xillybus_core.c:175:57:    got unsigned int [usertype] *
drivers/staging/xillybus//xillybus_core.c:309:39: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/xillybus//xillybus_core.c:309:39:    expected void [noderef] <asn:2>*<noident>
drivers/staging/xillybus//xillybus_core.c:309:39:    got unsigned int [usertype] *
drivers/staging/xillybus//xillybus_core.c:606:55: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/xillybus//xillybus_core.c:606:55:    expected void [noderef] <asn:2>*<noident>
drivers/staging/xillybus//xillybus_core.c:606:55:    got unsigned int [usertype] *

and goes on for a few screens.

$ sparse --version
0.4.4

Try a newer version and see if that fixes things.

thanks,

greg k-h
