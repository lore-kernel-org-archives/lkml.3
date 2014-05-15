Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaEOQte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:49:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33887 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaEOQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:49:33 -0400
Date: Thu, 15 May 2014 12:49:31 -0400 (EDT)
Message-Id: <20140515.124931.1801842437410594819.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sparc: add renameat2 syscall
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAJfpegsAUQZ0mxpqOeVj2SERT41Caw77irBHSTPMc0CaQp=uYA@mail.gmail.com>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-14-git-send-email-miklos@szeredi.hu>
	<CAJfpegsAUQZ0mxpqOeVj2SERT41Caw77irBHSTPMc0CaQp=uYA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 May 2014 09:49:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 May 2014 14:22:33 +0200

> On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> Cc: David S. Miller <davem@davemloft.net>
> 
> David,
> 
> I'll be sending a batch of patches with arch support for the renameat2
> syscall to Linus next week.  If you'd like me to send this as well,
> could you please ACK it?

For the 32-bit compat case on sparc64, you need to add a wrapper to
sign extend the oldfd and newfd arguments.

This usually occurs in arch/sparc/kernel/sys32.S, probably something
like:

SIGN2(sys32_renameat2, sys_renameat2, %o0, %o2)

and then you hook up sys32_renameat2 instead of sys_renameat2 in the
32-bit compat syscall table in syscall_64.S
