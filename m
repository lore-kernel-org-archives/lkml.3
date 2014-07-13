Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbaGMW0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 18:26:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:44735 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaGMW0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 18:26:00 -0400
Message-ID: <1405290324.20996.71.camel@pasglop>
Subject: Re: bit fields && data tearing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Dan <opendtv@yahoo.com>
Date: Mon, 14 Jul 2014 08:25:24 +1000
In-Reply-To: <53C2865B.5040200@hurleysoftware.com>
References: <20140712181328.GA8738@redhat.com>
	 <20140712205130.GA16437@redhat.com> <1405208082.20996.54.camel@pasglop>
	 <53C2865B.5040200@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-13 at 09:15 -0400, Peter Hurley wrote:
> 
> I'm not sure I understand your point here, Ben.
> 
> Suppose that two different spinlocks are used independently to
> protect r-m-w access to adjacent data. In Oleg's example,
> suppose spinlock 1 is used for access to the bitfield and
> spinlock 2 is used for access to freeze_stop.
> 
> What would prevent an accidental write to freeze_stop from the
> kt_1 thread?

My point was to be weary of bitfields in general because access
to them is always R-M-W, never atomic and that seem to escape
people regularily :-) (Among other problems such as endian etc...)

As for Oleg's example, it *should* have worked because the bitfield and
the adjacent freeze_stop should have been accessed using load/stores
that don't actually overlap, but the compiler bug causes the bitfield
access to not properly use the basic type of the bitfield, but escalate
to a full 64-bit R-M-W instead, thus incorrectly R-M-W'ing the field
next door.

Cheers,
Ben.




