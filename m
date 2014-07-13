Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaGMMbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 08:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaGMMbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 08:31:36 -0400
Date: Sun, 13 Jul 2014 14:29:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jakub Jelinek <jakub@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Dan <opendtv@yahoo.com>
Subject: Re: bit fields && data tearing
Message-ID: <20140713122950.GA16995@redhat.com>
References: <20140712181328.GA8738@redhat.com> <20140712205130.GA16437@redhat.com> <1405208082.20996.54.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405208082.20996.54.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13, Benjamin Herrenschmidt wrote:
>
> On Sat, 2014-07-12 at 22:51 +0200, Oleg Nesterov wrote:
> > OK, looks like this is compiler bug,
> >
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52080
> >
> > Thanks to Dan who informed me privately.
>
> So yes, there's is this compiler bug which means a bitfield
> access can cause a r-m-w access to a neighbouring field

Thanks. So I can forward this all back to bugzilla.

> but
> in general, I would be weary of bitfields anyway since accessing
> them isn't going to be atomic anyway... it's too easy to get things
> wrong and in most cases the benefit is yet to be demonstrated.

Sure, bit fields should be used with care. But the same arguments apply
to bitmasks, they are often used without "atomic" set/clear_bit.

> In your example, I don't see the point of the bitfield.

This is just test-case. The real code has more adjacent bit fields, only
the tracee can modify them, and only debugger can change ->freeze_stop.

Thanks,

Oleg.

