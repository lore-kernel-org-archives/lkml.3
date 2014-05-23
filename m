Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaEWJ2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:28:07 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53458 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751640AbaEWJ2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:28:04 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Jim Baxter'" <jim_baxter@mentor.com>, David Miller <davem@davemloft.net>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kamal@canonical.com" <kamal@canonical.com>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>, "fw@strlen.de" <fw@strlen.de>
Subject: RE: skbuff truesize incorrect.
Thread-Topic: skbuff truesize incorrect.
Thread-Index: AQHPdmhaL2lnKeimqUeV55a8ET8tq5tN5Lyg
Date: Fri, 23 May 2014 09:27:21 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724C54C@AcuExch.aculab.com>
References: <537E4AFD.20304@mentor.com>
	<20140522.152146.2116142050088142989.davem@davemloft.net>
	<537E5C63.7080607@mentor.com>
 <20140522.165833.414855217799383878.davem@davemloft.net>
 <537F130F.6080901@mentor.com>
In-Reply-To: <537F130F.6080901@mentor.com>
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

From: Jim Baxter
> On 22/05/14 21:58, David Miller wrote:
> > From: Jim Baxter <jim_baxter@mentor.com>
> > Date: Thu, 22 May 2014 21:21:55 +0100
> >
> >> If there are multiple clones for an skb all pointing at the same data,
> >> will that distort the memory used when they all have the same truesize?
> >
> > What is distorted about it?
> >
> > Each clone references exactly that much backing memory.
> >
> 
> Thank you for you help, I think distorted was the wrong word.
> 
> 
> I think I am confused what truesize is used for it looks like it is used
> to deallocate memory, is this correct?

No, it is used for receive flow control.
You need to count allocated memory (not data bytes) in order to
actually stop the system running out of memory.

	David



