Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaCRMxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:53:01 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52091 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCRMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:53:00 -0400
Date: Tue, 18 Mar 2014 05:52:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: noman pouigt <variksla@gmail.com>
Cc: rostedt@goodmis.org, rusty@rustcorp.com.au, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: atomic read and increment question
Message-ID: <20140318125256.GJ4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAES_P+-FDQKQSSSdJBY0ivGJtHOA6K4rYSy7z20HowUUVcHdJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAES_P+-FDQKQSSSdJBY0ivGJtHOA6K4rYSy7z20HowUUVcHdJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031812-7164-0000-0000-000000650246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 01:26:12AM -0700, noman pouigt wrote:
> Hello,
> 
> I looked through the documentation for atomic
> operations but couldn't find out the api for following
> operation:
> 
> x = 1;
> temp = atomic_read_increment(x);
> 
> so basically this will read the old value of x in temp
> and then increment x.
> 
> so temp = 1 and x = 2.
> 
> Is this api already available?

You want atomic_inc_return().  It returns the new value rather than the
old value, but you can do the following:

	temp = atomic_inc_return(&x) - 1;

							Thanx, Paul

