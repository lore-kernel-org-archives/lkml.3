Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaKXNbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:31:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbaKXNbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:31:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
References: <1416834210-61738-8-git-send-email-borntraeger@de.ibm.com> <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-x86_64@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15470.1416835748.1@warthog.procyon.org.uk>
From: David Howells <dhowells@redhat.com>
Date: Mon, 24 Nov 2014 13:30:58 +0000
Message-ID: <15567.1416835858@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> +#define get_scalar_volatile_pointer(x) ({ \
> +	typeof(x) *__p = &(x); \
> +	volatile typeof(x) *__vp = __p; \
> +	(void)(long)*__p; __vp; })
> +#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))

Might this cause two loads from memory under some conditions?  Once for the
fourth line and once for the fifth?

(Apologies if this has already been discussed)

David
