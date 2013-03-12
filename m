Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab3CLSWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:22:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab3CLSWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:22:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, sfr@canb.auug.org.au,
        Joakim.Tjernlund@transmode.se, arnd@arndb.de, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] UAPI: Fix endianness conditionals in linux/aio_abi.h
References: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk>
	<20130306204733.31327.97388.stgit@warthog.procyon.org.uk>
	<20130312163207.GI8869@kvack.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 12 Mar 2013 14:22:17 -0400
In-Reply-To: <20130312163207.GI8869@kvack.org> (Benjamin LaHaise's message of
	"Tue, 12 Mar 2013 12:32:07 -0400")
Message-ID: <x49boaov5pi.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> On Wed, Mar 06, 2013 at 08:47:33PM +0000, David Howells wrote:
>> In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be compared
>> against __BYTE_ORDER in preprocessor conditionals where these are exposed to
>> userspace (that is they're not inside __KERNEL__ conditionals).
>> 
>> However, in the main kernel the norm is to check for "defined(__XXX_ENDIAN)"
>> rather than comparing against __BYTE_ORDER and this has incorrectly leaked
>> into the userspace headers.
>> 
>> The definition of PADDED() in linux/aio_abi.h is wrong in this way.  Note that
>> userspace will likely interpret this and thus the order of fields in struct
>> iocb incorrectly as the little-endian variant on big-endian machines -
>> depending on header inclusion order.
>> 
>> [!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It might
>> be better to fix the ordering of aio_key and aio_reserved1 in struct iocb.
>
> It is unlikely that anyone has used the existing kernel headers and hit this 
> issue given that most existing users use the libaio.h include (which does not 
> get the endianness tests wrong).  Given that the kernel has always used the 
> correct endian mappings, this change is correct.

Agreed.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
