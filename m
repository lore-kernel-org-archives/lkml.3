Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaAPWon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:44:43 -0500
Received: from ozlabs.org ([203.10.76.45]:34509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaAPWoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:44:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Marek <mmarek@suse.com>, "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>,
        dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the signing_key.x509
In-Reply-To: <52D7FC59.1030702@suse.com>
References: <1389249983-31265-1-git-send-email-jlee@suse.com> <87eh49x3hh.fsf@rustcorp.com.au> <52D7FC59.1030702@suse.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Jan 2014 08:36:29 +1030
Message-ID: <877g9zvaxm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.com> writes:
> On 15.1.2014 05:39, Rusty Russell wrote:
>> "Lee, Chun-Yi" <joeyli.kernel@gmail.com> writes:
>>> From: Chun-Yi Lee <jlee@suse.com>
>>> v2:
>>> Using '$(shell /bin/pwd)' instead of '$(shell pwd)' for more reliable
>>> between different shells
>> 
>> Hmm, that's not a great test for equality.  How about:
>> 
>>      ifneq ($(realpath .), $(realpath $(srctree)))
>> 
>> That should cover all the cases.
>
> make 3.80 does not have realpath :(.

OK, I guess the former is the best compromise then.

Thanks,
Rusty.
