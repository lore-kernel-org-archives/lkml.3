Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab3APKpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:45:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758990Ab3APKps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:45:48 -0500
Date: Wed, 16 Jan 2013 10:45:47 +0000
From: thornber@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Message-ID: <20130116104546.GA3869@raspberrypi>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

I'll look through EnhanceIO this week.

There are several cache solutions out there; bcache, my dm-cache and
EnhanceIO seeming to be the favourites.  In suspect none of them are
without drawbacks, so I'd like to see if we can maybe work together.

I think the first thing we need to do is make it easy to compare the
performance of these impls.

I'll create a branch in my github tree with all three caches in.  So
it's easy to build a kernel with them.  (Mike's already combined
dm-cache and bcache and done some preliminary testing).

We've got some small test scenarios in our test suite that we run [1].
They certainly flatter dm-cache since it was developed using these.
It would be really nice if you could describe and provide scripts for
your test scenarios.  I'll integrate them with the test suite, and
then I can have some confidence that I'm seeing EnhanceIO in its best
light.

The 'transparent' cache issue is a valid one, but to be honest a bit
orthogonal to cache.  Integrating dm more closely with the block layer
such that a dm stack can replace any device has been discussed for
years and I know Alasdair has done some preliminary design work on
this.  Perhaps we can use your requirement to bump up the priority on
this work.

On Tue, Jan 15, 2013 at 09:19:10PM +0800, Amit Kale wrote:
> 5. We have designed our writeback architecture from
> scratch. Coalescing/bunching together of metadata writes and cleanup
> is much improved after redesigning of the EnhanceIO-SSD
> interface. The DM interface would have been too restrictive for
> this. EnhanceIO uses set level locking, which improves parallelism
> of IO, particularly for writeback.

I sympathise with this; dm-cache would also like to see a higher level
view of the io, rather than being given the ios to remap one by one.
Let's start by working out how much of a benefit you've gained from
this and then go from there.

> PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
> 
> This electronic transmission, and any documents attached hereto, may
> contain confidential, proprietary and/or legally privileged
> information. The information is intended only for use by the
> recipient named above. If you received this electronic message in
> error, please notify the sender and delete the electronic
> message. Any disclosure, copying, distribution, or use of the
> contents of information received in error is strictly prohibited,
> and violators will be pursued legally.

Please do not use this signature when sending to dm-devel.  If there's
proprietary information in the email you need to tell people up front
so they can choose not to read it.

- Joe


  [1] https://github.com/jthornber/thinp-test-suite/tree/master/tests/cache
