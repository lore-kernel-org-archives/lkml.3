Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaKFKKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:10:38 -0500
Received: from usevmg20.ericsson.net ([198.24.6.45]:64604 "EHLO
	usevmg20.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaKFKKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:10:34 -0500
X-AuditID: c618062d-f79206d0000014d2-39-545aed2c6fd2
From: Jon Maloy <jon.maloy@ericsson.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "Masahide Nakamura" <nakam@linux-ipv6.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: RE: ipv4: Use standard iovec primitive in raw_probe_proto_opt
Thread-Topic: ipv4: Use standard iovec primitive in raw_probe_proto_opt
Thread-Index: AQHP+YWcr4jP8eKgREeUjxe0YbkD45xTeqsAgAAA5ICAAAbkgP//2YxQ
Date: Thu, 6 Nov 2014 09:55:31 +0000
Message-ID: <A2BAEFC30C8FD34388F02C9B3121859D1C3087CA@eusaamb103.ericsson.se>
References: <20141105035536.GO7996@ZenIV.linux.org.uk>
 <20141105.155054.2198151263164321219.davem@davemloft.net>
 <20141105210745.GT7996@ZenIV.linux.org.uk>
 <20141105.165719.835728206041332333.davem@davemloft.net>
 <20141106032533.GU7996@ZenIV.linux.org.uk>
 <20141106055023.GA28865@gondor.apana.org.au>
 <20141106064318.GW7996@ZenIV.linux.org.uk>
 <20141106064629.GA29321@gondor.apana.org.au>
 <20141106071109.GX7996@ZenIV.linux.org.uk>
In-Reply-To: <20141106071109.GX7996@ZenIV.linux.org.uk>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.117.188.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42KZXLonSlfnbVSIwbFJZhZd/7awWMw538Ji
	0f1KxuLyrjlsFk0r/7FbHFsgZnH+73FWi697u1gcODy2rLzJ5LHtgKrHpk+T2D3arq1i8vi8
	Sc5j05O3TAFsUVw2Kak5mWWpRfp2CVwZO+63Mxbc5a94eO8tYwPjXp4uRk4OCQETiV+N3awQ
	tpjEhXvr2boYuTiEBI4wSqx+to8FwlnGKPHtfx87SBWbgIbEy2kdjCC2iECgxMztE8CKmAVm
	MUksWfSHDSQhLOAm8fDDDagid4nepQeYIGw3iUcLGoEaODhYBFQkeg4zgZi8Ar4SfSfDQCqE
	BPYzS/x4JABicwqYSzxovQjWySggK7H77HUwm1lAXOLWk/lMEEcLSCzZc54ZwhaVePn4H9Qz
	ShKTlp5jhajXkViw+xMbhK0tsWzha7B6XgFBiZMzn7BMYBSbhWTsLCQts5C0zELSsoCRZRUj
	R2lxalluupHBJkZgBB6TYNPdwbjnpeUhRgEORiUe3g3FUSFCrIllxZW5hxilOViUxHln1c4L
	FhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDY1lg72cTvjK2Q9lWW1hfzVn3v3Pt9f49ohZHi
	c7XcCo+kN7qNO6WLGtf+LpjXyfZ7hpzKh+/7z8hyLv3pNN86p9A9bQ6T9RcT0c7bZiUv+WXT
	J5wxmPdYdwHz2t+um+Z995b5G7ff0FmdQzY6MlFExz346eduheMrzhr+lDzk6NLF8pFJtkCJ
	pTgj0VCLuag4EQAmMzJmoQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Al Viro
> Sent: November-06-14 8:11 AM
> To: Herbert Xu
> Cc: David Miller; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> bcrl@kvack.org; Masahide Nakamura; Hideaki YOSHIFUJI
> Subject: Re: ipv4: Use standard iovec primitive in raw_probe_proto_opt
> 
> On Thu, Nov 06, 2014 at 02:46:29PM +0800, Herbert Xu wrote:
> > On Thu, Nov 06, 2014 at 06:43:18AM +0000, Al Viro wrote:
> > > On Thu, Nov 06, 2014 at 01:50:23PM +0800, Herbert Xu wrote:
> > > > +	/* We only need the first two bytes. */
> > > > +	err = memcpy_fromiovecend((void *)&icmph, msg->msg_iov, 0, 2);
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > > +	fl4->fl4_icmp_type = icmph.type;
> > > > +	fl4->fl4_icmp_code = icmph.code;
> > >
> > > That's more readable, but that exposes another problem in there - we
> > > read the same piece of userland data twice, with no promise
> > > whatsoever that we'll get the same value both times...
> >
> > Sure, but you have to be root anyway to write to raw sockets.
> 
> Point, but that might very well be a pattern to watch for - there's at least one
> more instance in TIPC (also not exploitable, according to TIPC folks) and such

I don't recall this, and I can't see where it would be either. Can you please
point to where it is?

///jon

> bugs are easily repeated...
> 
> BTW, I've picked the tun and macvtap related bits from another part of old
> queue; see vfs.git#untested-macvtap - it's on top of #iov_iter-net and it's
> really completely untested.  Back then I was mostly interested in killing as
> many ->aio_write() instances as I could, so it's only the "send" side of things.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
