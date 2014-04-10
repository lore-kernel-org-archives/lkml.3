Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160AbaDJDgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:36:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:52542 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934658AbaDJDgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:36:05 -0400
Message-ID: <1397100937.3671.160.camel@pasglop>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Date: Thu, 10 Apr 2014 13:35:37 +1000
In-Reply-To: <5346012A.50901@fb.com>
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>
	 <1397087273.3671.150.camel@pasglop> <1397088144.3671.155.camel@pasglop>
	 <5345F476.2000602@fb.com> <1397093815.3671.156.camel@pasglop>
	 <5346012A.50901@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 20:25 -0600, Jens Axboe wrote:
> On 2014-04-09 19:36, Benjamin Herrenschmidt wrote:
> > On Wed, 2014-04-09 at 19:31 -0600, Jens Axboe wrote:
> >> OK, I think we're seeing different symptoms of the same bug. Stay
> >> tuned, will have something for you to test shortly, I hope.
> >
> > Ah thanks. I'll defer the bisection then (it's painful on that machine
> > for various reasons....)
> 
> Can you try with these two patches applied?

Booted to login prompt once ... and twice. Much better ! :-)

Thanks a lot !

Not sure if it's related, but in the "good" boots (with the patch),
I see a truckload of:

systemd-udevd[3264]: starting version 204
sr 2:6:0:0: [sr0]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sr 2:6:0:0: [sr0]  
Sense Key : Illegal Request [current] 
sr 2:6:0:0: [sr0]  
Add. Sense: Logical block address out of range
sr 2:6:0:0: [sr0] CDB: 
Read(10): 28 00 00 00 00 00 00 00 01 00
end_request: critical target error, dev sr0, sector 0
Buffer I/O error on device sr0, logical block 0
[  OK  ] Started udev Kernel Device Manager.
sr 2:6:0:0: [sr0]  
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sr 2:6:0:0: [sr0]  
Sense Key : Illegal Request [current] 
sr 2:6:0:0: [sr0]  
Add. Sense: Logical block address out of range
sr 2:6:0:0: [sr0] CDB: 
 
   etc...

I might have a crap coaster in that drive. It doesn't prevent
the machine from working otherwise, so far...

Cheers,
Ben.


