Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3DZQoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:44:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41239 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab3DZQo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:44:29 -0400
Message-ID: <517AAED5.7040400@zytor.com>
Date: Fri, 26 Apr 2013 09:44:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2] x86: make DR*_RESERVED unsigned long
References: <CA+55aFwpLu0qNms=hkQr43yqD0K9DgESNm91OEWKT1ZuT8MU6Q@mail.gmail.com> <20130424072630.GB1780@gmail.com> <20130424170702.GA1867@redhat.com> <5178282D.9030902@zytor.com> <20130425144818.GA25921@redhat.com> <20130426163802.GA30351@redhat.com>
In-Reply-To: <20130426163802.GA30351@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 09:38 AM, Oleg Nesterov wrote:
> DR6_RESERVED and DR_CONTROL_RESERVED are used to clear the set
> bits in the "unsigned long" data, make them long to ensure that
> "&~" doesn't clear the upper bits.
> 
> This is only cleanup, the usage of ~DR*_RESERVED is safe but
> doesn't look clean and the pattern is error prone.
> 
> 	- do_debug:
> 
> 		dr6 &= ~DR6_RESERVED;
> 
> 	  this also wrongly clears 32-63 bits. Fortunately these
> 	  bits are reserved and must be zero.
> 

I don't think this is wrongly at all.  The whole point is to mask out
the bits that the handler doesn't want to deal with, so masking out the
reserved bits [63:32] seems reasonable to me.

The comment should probably be corrected, though.

	-hpa


