Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaCaWPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:15:22 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50772 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaCaWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:15:19 -0400
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org, paulus@samba.org,
        anton@samba.org, nfont@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/le: enable RTAS events support
In-Reply-To: <20140331104716.1385b516@bahia.local>
References: <20140328073344.26823.32931.stgit@bahia.local> <87vbuv9vaz.fsf@river.i-did-not-set--mail-host-address--so-tickle-me> <20140331104716.1385b516@bahia.local>
User-Agent: Notmuch/0.16 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 01 Apr 2014 09:15:11 +1100
Message-ID: <87ob0m8174.fsf@river.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033122-2000-0000-0000-0000106E287B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kurz <gkurz@linux.vnet.ibm.com> writes:
> On Mon, 31 Mar 2014 09:27:16 +1100
> Stewart Smith <stewart@linux.vnet.ibm.com> wrote:
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
> True... even though I am not so sure the compiler is likely to break
> things in this specific case where no bitfield crosses the byte boundary.
> Anyway, Nathan has done some work in the direction you suggest.

It's allowed to, and it's allowed to based on compiler flags or phase of
the moon (and I've seen odd things because of this in the past) and my
bet is that there's no automated regression test that actually checks
that a newly built kernel from all distros actually works for parsing RTAS.

Besides, for things like unsigned long version:8 can easily be replaced
by uint8_t and teh problem goes away (at least for that bit).

I just hope the code we're getting this from doesn't also use bitfields :)

