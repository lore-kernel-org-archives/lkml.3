Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaCYTr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:47:28 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46497 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaCYTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:47:26 -0400
Date: Tue, 25 Mar 2014 20:47:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, peterz@infradead.org, akpm@linux-foundation.org,
        andi.kleen@intel.com, rob@landley.net, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk, riel@redhat.com,
        snorcht@gmail.com, dhowells@redhat.com, luto@amacapital.net,
        daeseok.youn@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
Message-ID: <20140325194724.GV22728@two.firstfloor.org>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
 <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
 <871txqp2cr.fsf@tassilo.jf.intel.com>
 <5331CF58.8000909@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5331CF58.8000909@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 12:47:52PM -0600, Khalid Aziz wrote:
> I am not sure if it would be practical and useful to integrate this
> into any of the standard locking interfaces, but I have not looked
> into it much either. My initial intent is to let individual apps
> decide if they could benefit from this interface and code it in if
> so since the interface is meant to be very simple. Do you see any of
> the standard locking interfaces where it would make sense to
> integrate this feature in, or are you thinking of creating a new
> interface?

It would probably make sense to use by default with glibc adaptive mutexes.

> I am reluctant to make it too big since reading larger quantities
> from userspace will take longer and start to impact performance.
> Keeping shared data limited to 32-bits allows us to move it between
> userspace and kernel with one instruction.

You don't need to read/write more. Just reserve more so that it 
can be sensibly extended later.

The feature bits would only need to be written once when it is set up.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
