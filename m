Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbaEPJJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:09:07 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:48557 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaEPJJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:09:04 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.121.61]
In-Reply-To: <20140515.124931.1801842437410594819.davem@davemloft.net>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-14-git-send-email-miklos@szeredi.hu>
	<CAJfpegsAUQZ0mxpqOeVj2SERT41Caw77irBHSTPMc0CaQp=uYA@mail.gmail.com>
	<20140515.124931.1801842437410594819.davem@davemloft.net>
Date: Fri, 16 May 2014 11:09:02 +0200
Message-ID: <CAJfpegsyE4TCo5VBG2K2q=2hrnDN5kgZ_Qt-KUvwDSfcq1oitA@mail.gmail.com>
Subject: Re: [PATCH 13/15] sparc: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Miller <davem@davemloft.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 6:49 PM, David Miller <davem@davemloft.net> wrote:
> From: Miklos Szeredi <miklos@szeredi.hu>
> Date: Thu, 15 May 2014 14:22:33 +0200
>
>> On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> From: Miklos Szeredi <mszeredi@suse.cz>
>>>
>>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>>> Cc: David S. Miller <davem@davemloft.net>
>>
>> David,
>>
>> I'll be sending a batch of patches with arch support for the renameat2
>> syscall to Linus next week.  If you'd like me to send this as well,
>> could you please ACK it?
>
> For the 32-bit compat case on sparc64, you need to add a wrapper to
> sign extend the oldfd and newfd arguments.
>
> This usually occurs in arch/sparc/kernel/sys32.S, probably something
> like:
>
> SIGN2(sys32_renameat2, sys_renameat2, %o0, %o2)
>
> and then you hook up sys32_renameat2 instead of sys_renameat2 in the
> 32-bit compat syscall table in syscall_64.S

Are you sure?  None of the *at() functions (including renameat())  are in there.

Thanks,
Miklos
