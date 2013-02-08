Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946158Ab3BHKY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:24:26 -0500
Received: from mx0.aculab.com ([213.249.233.131]:52139 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760070Ab3BHKYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:24:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver
Date: Fri, 8 Feb 2013 10:23:08 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B713F@saturn3.aculab.com>
In-Reply-To: <1360267375.3605.32.camel@bwh-desktop.uk.solarflarecom.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver
Thread-Index: Ac4FbibiZe6p17gwTsqM52C0+pKkjgAd0Diw
References: <1360244360-2700-1-git-send-email-freddy@asix.com.tw> <1360267375.3605.32.camel@bwh-desktop.uk.solarflarecom.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Ben Hutchings" <bhutchings@solarflare.com>,
        "Freddy Xin" <freddy@asix.com.tw>
Cc: <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r18AORSs002959

> > +struct ax88179_rx_pkt_header {
> > +	u8	l4_csum_err:1,
> > +		l3_csum_err:1,
> > +		l4_type:3,
> > +		l3_type:2,
> > +		ce:1;
> > +
> > +	u8	vlan_ind:3,
> > +		rx_ok:1,
> > +		pri:3,
> > +		bmc:1;
> > +
> > +	u16	len:13,
> > +		crc:1,
> > +		mii:1,
> > +		drop:1;
> > +} __packed;
> 
> This won't work on both big-endian systems (assuming this works on x86).
> You apparently try to convert the structure in-place in
> ax88179_rx_fixup() by calling le32_to_cpus(); that may work if you
> define all the bitfields to be part of a u32 but it won't work with the
> current definition.

Trying to use bit fields to map hardware registers (etc) isn't a
good idea at all. The C standard says absolutely nothing about
the order in which the bits are allocated to the field names.
(There are at least 4 possible orederings.)

It is much better to define constants for the bit values and
explicitly mask them as required.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
