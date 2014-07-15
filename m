Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaGONy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:54:26 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:56255 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbaGONyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:54:25 -0400
Message-ID: <53C53288.0@hurleysoftware.com>
Date: Tue, 15 Jul 2014 09:54:16 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>
CC: Jakub Jelinek <jakub@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Dan <opendtv@yahoo.com>
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	 <20140712205130.GA16437@redhat.com> <1405208082.20996.54.camel@pasglop>	 <53C2865B.5040200@hurleysoftware.com> <1405290324.20996.71.camel@pasglop>
In-Reply-To: <1405290324.20996.71.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 06:25 PM, Benjamin Herrenschmidt wrote:
> On Sun, 2014-07-13 at 09:15 -0400, Peter Hurley wrote:
>>
>> I'm not sure I understand your point here, Ben.
>>
>> Suppose that two different spinlocks are used independently to
>> protect r-m-w access to adjacent data. In Oleg's example,
>> suppose spinlock 1 is used for access to the bitfield and
>> spinlock 2 is used for access to freeze_stop.
>>
>> What would prevent an accidental write to freeze_stop from the
>> kt_1 thread?
>
> My point was to be weary of bitfields in general because access
> to them is always R-M-W, never atomic and that seem to escape
> people regularily :-) (Among other problems such as endian etc...)
>
> As for Oleg's example, it *should* have worked because the bitfield and
> the adjacent freeze_stop should have been accessed using load/stores
> that don't actually overlap, but the compiler bug causes the bitfield
> access to not properly use the basic type of the bitfield, but escalate
> to a full 64-bit R-M-W instead, thus incorrectly R-M-W'ing the field
> next door.

Yeah, ok, so just a generic heads-up about non-atomicity of bitfields,
and not something specific to Oleg's example. Thanks.

Jonathan Corbet wrote a LWN article about this back in 2012:
http://lwn.net/Articles/478657/

I guess it's fixed in gcc 4.8, but too bad there's not a workaround for
earlier compilers (akin to -fstrict_volatile_bitfields without requiring
the volatile keyword).

Regards,
Peter Hurley



