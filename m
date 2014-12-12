Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbaLLJqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:46:43 -0500
Received: from mx0.aculab.com ([213.249.233.131]:34874 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934631AbaLLJqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:46:40 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
CC: "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] net/macb: add TX multiqueue support for gem
Thread-Topic: [PATCH v2 1/1] net/macb: add TX multiqueue support for gem
Thread-Index: AQHQFXjn6XWo+2ZgNk281xEEq+HfaJyLtH0Q
Date: Fri, 12 Dec 2014 09:45:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA0BA36@AcuExch.aculab.com>
References: <cover.1418291637.git.cyrille.pitchen@atmel.com>
	<87a3098203ee6eaa7a60607713a293d3258e2b58.1418291637.git.cyrille.pitchen@atmel.com>
 <20141211203103.4191887a@free-electrons.com>
In-Reply-To: <20141211203103.4191887a@free-electrons.com>
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

From: Thomas Petazzoni
> On Thu, 11 Dec 2014 11:16:51 +0100, Cyrille Pitchen wrote:
> 
> > +#define GEM_ISR1				0x0400
> > +#define GEM_ISR2				0x0404
> > +#define GEM_ISR3				0x0408
> > +#define GEM_ISR4				0x040c
> > +#define GEM_ISR5				0x0410
> > +#define GEM_ISR6				0x0414
> > +#define GEM_ISR7				0x0418
> 
> What about doing instead:
> 
> #define GEM_ISR(q)				((q) == 0 ? MACB_ISR : 0x400 + (q) << 2)
> 
> And ditto for all other registers, which will save a lot of boring repeated code.

It will probably add a lot of object code and, depending on how often
the registers are accesses, might have performance impact.

Having:
#define GEM_ISR(n) (0x400 + (n) << 4)
will save source code.

	David



