Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaJQSK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:10:59 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:58748 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaJQSK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:10:57 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Thread-Topic: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Thread-Index: AQHP6cUG28F+qHxVJUawV10ZLnQBUpw0c9QAgAARKYCAABFG8A==
Date: Fri, 17 Oct 2014 18:10:54 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E33A2@US01WEMBX2.internal.synopsys.com>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413521043-7587-2-git-send-email-sudipm.mukherjee@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1C9D8926@AcuExch.aculab.com>
 <20141017100325.GA21465@sudip-PC>
In-Reply-To: <20141017100325.GA21465@sudip-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> Sent: Friday, October 17, 2014 3:03 AM
> 
> On Fri, Oct 17, 2014 at 09:02:00AM +0000, David Laight wrote:
> > From: Of Sudip Mukherjee
> > > modified the function to have a single return statement at the end
> > > instead of multiple return statement in the middle of the function
> > > to improve the readability of the code.
> >
> > Many of us would disagree with you there.
> > Early returns actually make the code easier to read, certainly
> > better than a goto 'end of function'.
> >
> actually , frankly speaking, this first return statement was also easier for me to understand. But in
> my v1 patch , Paul mentioned :
> >For a long function like this, I'd rather keep a single return point at
> >the end.
> so I thought he meant all the return statements in the function.

What I didn't like about your first patch was that there were two
places where the spinlock was released. I think that is error-prone,
as can be seen by the original bug. But I am OK with leaving the
first return statement as-is, since the spinlock is not held there.

So I think we should apply patch 1, and drop patch 2.

-- 
Paul

