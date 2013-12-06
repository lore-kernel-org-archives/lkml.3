Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab3LFSZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:25:14 -0500
Received: from dmz-mailsec-scanner-2.mit.edu ([18.9.25.13]:45967 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758585Ab3LFSZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:25:09 -0500
X-AuditID: 1209190d-b7ef66d000000c40-5b-52a21684529a
Date: Fri, 6 Dec 2013 13:25:04 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 9/9] random: simplify accounting code
Message-ID: <20131206182503.GK8043@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
 <20131113080841.GW16018@ringworld.MIT.EDU>
 <20131206011347.GD9010@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206011347.GD9010@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsUixCmqrNsitijIoKVPz2LaRnGL3XMWs1hc
	3jWHzYHZ48yCI+wenzfJeZxo+cIawBzFZZOSmpNZllqkb5fAlXG3YQdbwQe2ip0nLrI2MO5k
	7WLk4JAQMJG4d0mni5ETyBSTuHBvPRuILSQwm0li5VGOLkYuIHsDo8T+W/sZIZyfjBLL9u1l
	AmlmEVCROLvSDqSBTUBB4sf8dcwgNSIC3YwSTUf2s4PUCAtYShzokAKp4RUwlfgy9RE7xJxG
	RonuXb9YIBKCEidnPgGzmQW0JG78ewk2n1lAWmL5Pw6QMKeAnsSj37OZQGxRoLVTTm5jm8Ao
	MAtJ9ywk3bMQuhcwMq9ilE3JrdLNTczMKU5N1i1OTszLSy3SNdLLzSzRS00p3cQIDllJ3h2M
	7w4qHWIU4GBU4uHlWLUgSIg1say4MvcQoyQHk5Ior67ooiAhvqT8lMqMxOKM+KLSnNTiQ4wS
	HMxKIrxH7iwMEuJNSaysSi3Kh0lJc7AoifPe5LAPEhJITyxJzU5NLUgtgsnKcHAoSfBaggwV
	LEpNT61Iy8wpQUgzcXCCDOcBGs4NUsNbXJCYW5yZDpE/xagoJc7bJAKUEABJZJTmwfXCUsor
	RnGgV4R5A0DaeYDpCK77FdBgJqDBzQ/mgQwuSURISTUw2lmb3dgW/eMRr7U+n5Qt+/QP3qp7
	rp9yU9cyEs3pdk1WqZz0NTXwSFzCGjVOtqDiI47X/oVF2Cop/qiIPOP4td8hYOfd890TRB56
	nFt6zcX/0QGDZU8XvY6V1JA1mPpqttYbo+//Cg8/nPLJXizpY/R6zueWvo3cEtWSArniZ794
	ZPLap/xRYinOSDTUYi4qTgQAj4KYFwQDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 08:13:47PM -0500, Theodore Ts'o wrote:
> On Wed, Nov 13, 2013 at 03:08:41AM -0500, Greg Price wrote:
> > +	if (ibytes && cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
> > +		goto retry;
> 
> I wonder if we would be better dropping the test for ibytes here, so
> the above condition reads:
> 
> 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
> 		goto retry;
> 
> It further simplifies the code, and it means that if we it turns out
> that ibytes is zero (meaning there was no entropy available) but some
> additional entropy comes in, we might acutally end up retrying and
> successfully grabbing that entropy for the caller.

Sure, that'd be reasonable.  I didn't do that mainly because I wanted
to preserve existing behavior wherever possible in these cleanups, to
make them easy to read and review.

Greg

