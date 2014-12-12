Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934818AbaLLKAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:00:47 -0500
Received: from mx0.aculab.com ([213.249.233.131]:37462 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934654AbaLLKAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:00:45 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Cyrille Pitchen'" <cyrille.pitchen@atmel.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>
CC: "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] net/macb: add TX multiqueue support for gem
Thread-Topic: [PATCH v2 1/1] net/macb: add TX multiqueue support for gem
Thread-Index: AQHQFXjn6XWo+2ZgNk281xEEq+HfaJyLtH0Q///0YwCAABC9QA==
Date: Fri, 12 Dec 2014 09:59:36 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA0BA7D@AcuExch.aculab.com>
References: <cover.1418291637.git.cyrille.pitchen@atmel.com>
	<87a3098203ee6eaa7a60607713a293d3258e2b58.1418291637.git.cyrille.pitchen@atmel.com>
 <20141211203103.4191887a@free-electrons.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CA0BA36@AcuExch.aculab.com>
 <548AAE66.8070501@atmel.com>
In-Reply-To: <548AAE66.8070501@atmel.com>
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

From: Cyrille Pitchen [...
> > It will probably add a lot of object code and, depending on how often
> > the registers are accesses, might have performance impact.
> >
> > Having:
> > #define GEM_ISR(n) (0x400 + (n) << 4)
> > will save source code.
> >
> > 	David
> >
> >
> >
> So you suggest that we keep the unsigned int fields ISR, IMR, IER, IDR, TBQP in
> the struct macb_queue and initialize them once for all in macb_probe() like
> patch v2 does but only replace the GEM_ISR1 .. GEM_ISR7 defines by GEM_ISR(n)
> in macb.h?
> 
> This way there would be to test at run time and we can handle the special
> register mapping of queue0.
> 
> Is it what you meant?

In one word, yes.

	David



