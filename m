Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaLDGK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:10:58 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:16949 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbaLDGK4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:10:56 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Kirill A. Shutemov'" <kirill@shutemov.name>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 4 Dec 2014 14:10:53 +0800
Subject: RE: [RFC V2] mm:add zero_page _mapcount when mapped into user space
Thread-Topic: [RFC V2] mm:add zero_page _mapcount when mapped into user space
Thread-Index: AdAOI2qtDF+YegGcTl66h334j0xBcQBYQopQ
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313E6@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313E0@CNBJMBX05.corpusers.net>
 <20141202113014.GA22683@node.dhcp.inet.fi>
In-Reply-To: <20141202113014.GA22683@node.dhcp.inet.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> Sent: Tuesday, December 02, 2014 7:30 PM
> To: Wang, Yalin
> Cc: 'linux-kernel@vger.kernel.org'; 'linux-mm@kvack.org'; 'linux-arm-
> kernel@lists.infradead.org'
> Subject: Re: [RFC V2] mm:add zero_page _mapcount when mapped into user
> space
> 
> On Tue, Dec 02, 2014 at 05:27:36PM +0800, Wang, Yalin wrote:
> > This patch add/dec zero_page's _mapcount to make sure the mapcount is
> > correct for zero_page, so that when read from /proc/kpagecount,
> > zero_page's mapcount is also correct, userspace process like procrank
> > can calculate PSS correctly.
> 
> I don't have specific code path to point to, but I would expect zero page
> with non-zero mapcount would cause a problem with rmap.
> 
> How do you test the change?
> 
I just test it to see the mapcount from /proc/pid/pagemap  and /proc/kpagecount ,
It works well,
The problem is that when I see /proc/pid/smaps ,
The Rss / Pss don't calculate zero_page map,
Because smaps_pte_entry() --> vm_normal_page( ),
Will return NULL for zero_page,

But when userspace process cat /proc/pid/pagemap  ,
It will see zero_page mapped,
And will treat as Rss ,  
This is weird, should we also omit zero_page in /proc/pid/pagemap ?
Or add zero_page as Rss in /proc/pid/smaps ? 

I think we should add zero_page into Rss ,
Because it is really mapped into userspace address space.
And will let userspace memory analysis more accurate .

Thanks





