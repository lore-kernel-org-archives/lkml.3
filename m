Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaETOJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:09:03 -0400
Received: from smtp.eu.citrix.com ([185.25.65.24]:47724 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaETOJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:09:00 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 10:08:59 EDT
X-IronPort-AV: E=Sophos;i="4.98,874,1392163200"; 
   d="scan'208";a="18227043"
From: Felipe Franciosi <felipe.franciosi@citrix.com>
To: "'Vitaly Kuznetsov'" <vkuznets@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jerry.snitselaar@oracle.com" <jerry.snitselaar@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "Roger Pau Monne" <roger.pau@citrix.com>
Subject: RE: [Xen-devel] Backport request to stable of two performance
 related fixes for xen-blkfront (3.13 fixes to earlier trees)
Thread-Topic: [Xen-devel] Backport request to stable of two performance
 related fixes for xen-blkfront (3.13 fixes to earlier trees)
Thread-Index: AQHPdBF/9eOx952jVEWObJvrwQWy4ZtJI9sAgAA1CuuAACSXUA==
Date: Tue, 20 May 2014 13:59:05 +0000
Message-ID: <9F2C4E7DFB7839489C89757A66C5AD625AC66D@AMSPEX01CL03.citrite.net>
References: <20140514191122.GA7659@phenom.dumpdata.com>
	<8738g44wxp.fsf@vitty.brq.redhat.com>	<87ppj8zsfb.fsf@vitty.brq.redhat.com>
 <537B2F2C.4080905@citrix.com> <87lhtwznhl.fsf@vitty.brq.redhat.com>
In-Reply-To: <87lhtwznhl.fsf@vitty.brq.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.69.135.199]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-DLP: AMS1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4KE9Dn4012750

I had a small side-bar thread with Vitaly discussing the comprehensiveness of his measurements and how his tests are being conducted. He will report new results as they become available.

In the meantime, I stand behind that the patches need to be backported and there is a regression if we don't do that.
Ubuntu has already provided a test kernel with the patches pulled in.  I will test those as soon as I get the chance (hopefully by the end of the week).
See: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1319003

Felipe

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: 20 May 2014 12:41
> To: Roger Pau Monne
> Cc: Konrad Rzeszutek Wilk; axboe@kernel.dk; Felipe Franciosi;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org; jerry.snitselaar@oracle.com; xen-
> devel@lists.xenproject.org
> Subject: Re: [Xen-devel] Backport request to stable of two performance
> related fixes for xen-blkfront (3.13 fixes to earlier trees)
> 
> Roger Pau MonnÃ© <roger.pau@citrix.com> writes:
> 
> > On 20/05/14 11:54, Vitaly Kuznetsov wrote:
> >> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> >>
> >>> 1) ramdisks (/dev/ram*) (persistent grants and indirect descriptors
> >>> disabled)
> >>
> >> sorry, there was a typo. persistent grants and indirect descriptors
> >> are enabled with ramdisks, otherwise such testing won't make any sense.
> >
> > I'm not sure how is that possible, from your description I get that
> > you are using 3.11 on the Dom0, which means blkback has support for
> > persistent grants and indirect descriptors, but the guest is RHEL7,
> > that's using the 3.10 kernel AFAICT, and this kernel only has
> > persistent grants implemented.
> 
> RHEL7 kernel is mostly merged with 3.11 in its Xen part, we have indirect
> descriptors backported.
> 
> Actually I tried my tests with upstream (Fedora) kernel and results were
> similar. I can try comparing e.g. 3.11.10 with 3.12.0 and provide exact
> measurements.
> 
> --
>   Vitaly
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
