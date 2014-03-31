Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaCaWtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:49:50 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40820 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaCaWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:49:48 -0400
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kurz <gkurz@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, anton@samba.org, nfont@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/le: enable RTAS events support
In-Reply-To: <1396266973.11529.77.camel@pasglop>
References: <20140328073344.26823.32931.stgit@bahia.local> <87vbuv9vaz.fsf@river.i-did-not-set--mail-host-address--so-tickle-me> <1396266973.11529.77.camel@pasglop>
User-Agent: Notmuch/0.16 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 01 Apr 2014 09:49:41 +1100
Message-ID: <87a9c67zlm.fsf@river.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033122-3568-0000-0000-0000052ECD23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> On Mon, 2014-03-31 at 09:27 +1100, Stewart Smith wrote:
>> Greg Kurz <gkurz@linux.vnet.ibm.com> writes:
>> >  struct rtas_error_log {
>> > +#ifdef __BIG_ENDIAN__
>> > +	/* Byte 0 */
>> >  	unsigned long version:8;		/* Architectural version */
>> > +	/* Byte 1 */
>> 
>> I think it would be great if we got rid of the usage of bitfields. As
>> soon as the mood of the compiler changes, this code is going to break.
>
>  ... as would a whole pile of kernel code including filesystems :)
>
> Now, don't get me wrong, I hate bitfields as much as you do for the same
> reasons. However (unfortunately ?) we've somewhat painted ourselves into
> a corner here in kernel-land and I suspect gcc would have a very hard
> time changing the format considering how many people did just the same
> we did.
>
> Now if we were a userspace program, I would still insist on fixing it on
> the ground on not depending on gcc but this is the kernel ... we have
> more gcc'isms than spots on the face of a 14 yrs old..

A quick grep didn't show up anything that looked like on disk
formats... at least for anything I care about :)

Maybe I've spent too long writing code for more than one compiler :)

