Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3GLKMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:12:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10583 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab3GLKMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:12:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,652,1367971200"; 
   d="scan'208";a="36599486"
Message-ID: <51DFD67E.6000507@citrix.com>
Date: Fri, 12 Jul 2013 11:12:14 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH RFC 4/4] xen-block: introduce a new request
 type to unmap grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>	<1373288607-1876-5-git-send-email-roger.pau@citrix.com>	<20130708194152.GJ4927@phenom.dumpdata.com> <51DD271B.3010408@citrix.com> <51DEB795.3000602@citrix.com> <51DECB4D.4020009@citrix.com> <51DECEC3.7090306@citrix.com> <51DED3B6.9090601@citrix.com>
In-Reply-To: <51DED3B6.9090601@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 16:48, Roger Pau Monné wrote:
> On 11/07/13 17:26, David Vrabel wrote:
>> On 11/07/13 16:12, Roger Pau Monné wrote:
>>> On 11/07/13 15:48, David Vrabel wrote:
>>>> It also seems odd to have the backend decide how much frontend resource
>>>> can be consumed at anyone time.  It's not clear how the backend is
>>>> supposed to know how many persistent grants it should hang on to.
>>>
>>> blkfront has to at least persistently map the same grants as the
>>> backend. blkfront could persistently map all grants, but then we will
>>> have grant shortage, and I doubt there's much performance gain from
>>> persistently mapping grants in blkfront but not blkback (since the
>>> biggest performance penalty comes from the unmapping done in blkback and
>>> TLB flush involved).
>>
>> I'm saying that the frontend needs to be able to set a cap on the number
>> of persistent grants kept by the backend.  If other demands on a
>> domain's grant table resource means it can only spare G grants for a
>> particular frontend it needs to be able to ensure this (with the
>> cooperation of the backend).
> 
> We could easily negotiate the maximum number of persistent grants with
> the backend using a xenstore node, but how is blkfront going to decide
> how many persistent grants it wants to use? Should we coordinate this
> somehow with all the users of the grant table?
> 
> Doing it in the backend doesn't seem to me like a really bad approach,
> the admin of the host should know the maximum number of disks/nics a
> guest can have, and thus set the maximum number of persistent grants
> appropriately (and also tune gnttab_max_nr_frames if needed).

That sounds reasonable.  The host admin doesn't necessarily know how
many grant entries the guest might use for inter-domain communication
but they can certainly allow for a reasonable of spare entries for this.

David
