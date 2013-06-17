Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3FQFDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:03:16 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:45690 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3FQFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:03:15 -0400
Date: Mon, 17 Jun 2013 07:03:10 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3/9] s390: Replace weird use of PTR_RET.
Message-ID: <20130617050310.GA4560@osiris>
References: <87ehc2rczo.fsf@rustcorp.com.au>
 <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
 <1371357768-4968-3-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371357768-4968-3-git-send-email-rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061704-3548-0000-0000-000005B02DB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 02:12:42PM +0930, Rusty Russell wrote:
> Saves repeating "(void __force *)__uptr" but it's less clear.  Using
> the output of PTR_RET() to determine the error rather than just
> testing IS_ERR() is odd.

Ok, if it's confusing I won't mind if it gets changed. I intended to
keep the code as short as possible, but.. ;)

> For example, I *assume* __gptr_to_uptr() never returns NULL?  Because
> the __ret would be 0 for the old code.  The new version is clearer, IMHO:
> it would try to get_user() on that address.

__gptr_to_uptr() could return 0 and it's not an error case. In that case
it should indeed try a to get_user() on that address.

> If you hate this variant, I can just s/PTR_RET/PTR_ERR_OR_ZERO/ instead.

Your patch is fine.

> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/s390/kvm/gaccess.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

