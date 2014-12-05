Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaLEIIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:08:48 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:19528 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbaLEIIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:08:45 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 5 Dec 2014 16:08:42 +0800
Subject: RE: [RFC V2] mm:add zero_page _mapcount when mapped into user space
Thread-Topic: [RFC V2] mm:add zero_page _mapcount when mapped into user space
Thread-Index: AdAQVi6i9fnYaniFTiOXXd35RG3ixgADGPWA
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313EC@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313E0@CNBJMBX05.corpusers.net>
	<20141202113014.GA22683@node.dhcp.inet.fi>
	<35FD53F367049845BC99AC72306C23D103E688B313E6@CNBJMBX05.corpusers.net>
	<20141204122813.GA523@node.dhcp.inet.fi>
 <CALYGNiPWw6=tryWn_kCs+6H1uSjApBDnqORxuNEd=DuGCo71qA@mail.gmail.com>
In-Reply-To: <CALYGNiPWw6=tryWn_kCs+6H1uSjApBDnqORxuNEd=DuGCo71qA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB588v5E008332

> -----Original Message-----
> From: Konstantin Khlebnikov [mailto:koct9i@gmail.com]
> Sent: Friday, December 05, 2014 2:39 PM
> To: Kirill A. Shutemov
> Cc: Wang, Yalin; linux-kernel@vger.kernel.org; linux-mm@kvack.org; linux-
> arm-kernel@lists.infradead.org
> Subject: Re: [RFC V2] mm:add zero_page _mapcount when mapped into user
> space
> 
> On Thu, Dec 4, 2014 at 3:28 PM, Kirill A. Shutemov <kirill@shutemov.name>
> wrote:
> > On Thu, Dec 04, 2014 at 02:10:53PM +0800, Wang, Yalin wrote:
> >> > -----Original Message-----
> >> > From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> >> > Sent: Tuesday, December 02, 2014 7:30 PM
> >> > To: Wang, Yalin
> >> > Cc: 'linux-kernel@vger.kernel.org'; 'linux-mm@kvack.org';
> >> > 'linux-arm- kernel@lists.infradead.org'
> >> > Subject: Re: [RFC V2] mm:add zero_page _mapcount when mapped into
> >> > user space
> >> >
> >> > On Tue, Dec 02, 2014 at 05:27:36PM +0800, Wang, Yalin wrote:
> >> > > This patch add/dec zero_page's _mapcount to make sure the
> >> > > mapcount is correct for zero_page, so that when read from
> >> > > /proc/kpagecount, zero_page's mapcount is also correct, userspace
> >> > > process like procrank can calculate PSS correctly.
> 
> Instead of tweaking mapcount you could mark zero-pages in /proc/kpageflags
> and handle them accordingly in userspace. Or mark zero pages with special
> magic _mapcount and detect it in /proc/kpagecount.
> 
I think add KPF_ZERO_PAGE in kpageflags is better.
I will make another patch for review .

Thanks
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
