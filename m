Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaAZSBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 13:01:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20715 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaAZSBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 13:01:37 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140125210659.GA15756@u109add4315675089e695.ant.amazon.com>
References: <1390505326-9368-1-git-send-email-msw@linux.com> <1390555293.2124.6.camel@kazak.uk.xensource.com> <1390577782.13513.8.camel@kazak.uk.xensource.com> <20140125210659.GA15756@u109add4315675089e695.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [Xen-devel] [PATCH] xen-blkback: fix memory leak when persistent grants are used
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sun, 26 Jan 2014 13:01:14 -0500
To: Matt Wilson <msw@linux.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Matt Wilson <msw@amazon.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Matt Rushton <mrushton@amazon.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
Message-ID: <ecc2d6a2-e9c9-43a0-afe5-abca9ea47b07@email.android.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Wilson <msw@linux.com> wrote:
>On Fri, Jan 24, 2014 at 03:36:22PM +0000, Ian Campbell wrote:
>> On Fri, 2014-01-24 at 09:21 +0000, Ian Campbell wrote:
>> > On Thu, 2014-01-23 at 11:28 -0800, Matt Wilson wrote:
>> > > From: Matt Rushton <mrushton@amazon.com>
>> > > 
>> > > Currently shrink_free_pagepool() is called before the pages used
>for
>> > > persistent grants are released via free_persistent_gnts(). This
>> > > results in a memory leak when a VBD that uses persistent grants
>is
>> > > torn down.
>> > 
>> > This may well be the explanation for the memory leak I was
>observing on
>> > ARM last night. I'll give it a go and let you know.
>> 
>> Results are a bit inconclusive unfortunately, it seems like I am
>seeing
>> some other leak too (or instead).
>> 
>> Totally unscientifically it does seem to be leaking more slowly than
>> before, so perhaps this patch has helped, but nothing conclusive I'm
>> afraid.
>
>Testing here looks good. I don't know if perhaps something else is
>going on with ARM...
>
>> I don't think that quite qualifies for a Tested-by though, sorry.
>
>How about an Acked-by? ;-)
>
>--msw


How big and often does this leak occur - that this patch fixes?

I think there is one comment from Roger that needs to be addressed? Maybe I missed the resolution?

Thanks!
