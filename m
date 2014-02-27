Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaB0Ecj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:32:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbaB0Eci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:32:38 -0500
Message-ID: <530EBFC7.9030309@zytor.com>
Date: Wed, 26 Feb 2014 20:32:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ben Pfaff <blp@nicira.com>
CC: Joe Perches <joe@perches.com>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
References: <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722> <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com> <1393472326.24588.82.camel@joe-AO722> <20140227040050.GA8449@nicira.com> <530EBCED.9020705@zytor.com> <20140227042636.GA9592@nicira.com>
In-Reply-To: <20140227042636.GA9592@nicira.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 08:26 PM, Ben Pfaff wrote:
> 
>> Because sizeof(_Bool) is a little bit special compare to sizeof(long).
>> In the case of long, all sizeof(long) * 8 bits are use in the actual value.
>> But for the _Bool, only the 1 bit is used in the 8 bits size. In other words,
>> the _Bool has a special case of the actual bit size is not a multiple of 8.

Quite frankly, this is silly in my opinion, *and* it is not guaranteed
by C either (read about "trap representations").

>> Sparse has two hats, it is a C compiler front end, and more often it is
>> used in the Linux kernel source sanitize checking. Depending on the sizeof
>> _Bool sounds a little bit suspicious in the kernel. I would love to the heard
>> your actual usage case of the sizeof(_Bool). Why do you care about this
>> warning?

Anything that moves data around in a generic fashion.  It can be as
simple as:

	memcpy(foo, bar, sizeof *foo);

	-hpa

