Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaCTLOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:14:54 -0400
Received: from smtp.eu.citrix.com ([185.25.65.24]:43266 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTLOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:14:52 -0400
X-IronPort-AV: E=Sophos;i="4.97,694,1389744000"; 
   d="scan'208";a="11873011"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Davies" <Jonathan.Davies@citrix.com>
Subject: RE: [PATCH net-next v7 9/9] xen-netback: Aggregate TX unmap
 operations
Thread-Topic: [PATCH net-next v7 9/9] xen-netback: Aggregate TX unmap
 operations
Thread-Index: AQHPOYYi+CJloEb6V06vjlUaE/Z1Xpro7RCAgADjGoCAABdh0A==
Date: Thu, 20 Mar 2014 11:14:51 +0000
Message-ID: <9AAE0902D5BC7E449B7C8E4E778ABCD0292550@AMSPEX01CL01.citrite.net>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
 <1394142511-14827-10-git-send-email-zoltan.kiss@citrix.com>
 <532A0915.5090006@citrix.com> <20140320104855.GA16285@zion.uk.xensource.com>
In-Reply-To: <20140320104855.GA16285@zion.uk.xensource.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.80.2.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: AMS1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Wei Liu [mailto:wei.liu2@citrix.com]
> Sent: 20 March 2014 10:49
> To: Zoltan Kiss
> Cc: Ian Campbell; Wei Liu; xen-devel@lists.xenproject.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jonathan Davies;
> Paul Durrant
> Subject: Re: [PATCH net-next v7 9/9] xen-netback: Aggregate TX unmap
> operations
> 
> On Wed, Mar 19, 2014 at 09:16:05PM +0000, Zoltan Kiss wrote:
> > Hi,
> >
> > I'm thinking about revoking this patch: it's value is pretty small,
> > but it causes performance regression on Win7 guests. And probably it
> > is not the best solution for this problem. It might be the delay it
> > takes the dealloc thread to be scheduled is enough.
> > What do you think?
> >
> 
> Can you elaborate? What makes Win7 so special? What's performance
> impact to other guests?
> 

It won't be Win7 specifically I expect. It will likely by any version of Windows, or any other OS that limits the TXs-in-flight so aggressively. Basically you need to TX-complete reasonably frequently otherwise your throughput drops off a lot. IIRC at Solarflare we found every ~500us to be just about frequent enough for hitting 10G.

  Paul
