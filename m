Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbaCEPLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:11:09 -0500
Received: from mx0.aculab.com ([213.249.233.131]:38198 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757558AbaCEPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:11:04 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] phy: fix compiler array bounds warning on settings[]
Thread-Topic: [PATCH] phy: fix compiler array bounds warning on settings[]
Thread-Index: AQHPOAruIxtn6MjoSU2S08w3Vpy7W5rSNHzAgABhKYCAAARCkA==
Date: Wed, 5 Mar 2014 15:10:34 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D1D1E@AcuExch.aculab.com>
References: <20140305003544.23016.55079.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6D1440@AcuExch.aculab.com>
 <CAErSpo5Pb2bABmnQZ04KRqjU=38=Pcr2OQv8hUJd_hv69QVc-A@mail.gmail.com>
In-Reply-To: <CAErSpo5Pb2bABmnQZ04KRqjU=38=Pcr2OQv8hUJd_hv69QVc-A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s25FBJm2017308

From: Bjorn Helgaas
> On Wed, Mar 5, 2014 at 2:10 AM, David Laight <David.Laight@aculab.com> wrote:
> > From: Bjorn Helgaas
> >> With -Werror=array-bounds, gcc v4.7.x warns that in phy_find_valid(), the
> >> settings[] "array subscript is above array bounds", I think because idx is
> >> a signed integer and if the caller supplied idx < 0, we pass the guard but
> >> still reference out of bounds.
> >
> > Not rejecting the patch but...
> >
> > Just indexing an array with 'int' shouldn't cause this warning,
> > so somewhere a caller must actually be passing an idx < 0.
> >
> > While changing the type to unsigned will make the comparison
> > against the array bound reject the -1, I suspect that the
> > specific call path didn't really intend passing a hard-coded -1.
> >
> > It might be worth trying to locate the call site that passes -1.
> 
> I agree 100%.  If that's the case, we definitely should find that
> caller rather than apply this patch.  I'll look more today.

You might want to apply the patch as well :-)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
