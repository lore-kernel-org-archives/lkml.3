Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaKXKEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:04:14 -0500
Received: from mx0.aculab.com ([213.249.233.131]:44536 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753314AbaKXKEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:04:10 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Al Viro'" <viro@ZenIV.linux.org.uk>
CC: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: RE: [RFC] situation with csum_and_copy_... API
Thread-Topic: [RFC] situation with csum_and_copy_... API
Thread-Index: AQHQBWgr4bLXouueRUuDoiZfcNPHWpxrWCtwgAAiqoCABBR7cA==
Date: Mon, 24 Nov 2014 10:03:05 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9F9AE7@AcuExch.aculab.com>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
 <20141119213006.GE7996@ZenIV.linux.org.uk>
 <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141120222506.GS7996@ZenIV.linux.org.uk>
 <1416524035.8629.54.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141121084956.GT7996@ZenIV.linux.org.uk>
 <063D6719AE5E284EB5DD2968C1650D6D1C9F6930@AcuExch.aculab.com>
 <20141121193911.GU7996@ZenIV.linux.org.uk>
In-Reply-To: <20141121193911.GU7996@ZenIV.linux.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro
> On Fri, Nov 21, 2014 at 05:42:55PM +0000, David Laight wrote:
> 
> > Callers of kernel_send/recvmsg() could easily be using a wrapper
> > function that creates the 'msghdr'.
> > When the want to send the remaining part of a buffer the old iterator
> > will no longer be available - just the original iov and the required offset.
> 
> Er...  So why not copy a struct iov_iter to/from msg->msg_iter, then?
> It's not as it had been particulary large - 5 words isn't much...
> 
> I'm not at all sure that _anything_ has valid reasons for draining iovecs.
> Maintaining a struct iov_iter and modifying it is easy and actually faster...
> 
> Right now the main examples outside of net/* are due to unfortunate
> limitations of ->sendmsg() - until now it had no way to be told that
> desired data starts at offset.  With ->msg_iter it obviously becomes
> possible...

It may well be easier for code that only has to run in a new kernel.
But for code that has run in old kernels as well you still need
to modify the iov[].

This is also true of userspace - there is no way of completing
a partial transfer without modifying the iov[] to allow for the
partial transfer.

Note that I'm not suggesting that any of the 'write' functions
should ever modify an iov[].

	David



