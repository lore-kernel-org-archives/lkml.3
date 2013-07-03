Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab3GCPHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:07:25 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:46925
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab3GCPHY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:07:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: Christian Ruppert <christian.ruppert@abilis.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: RE: [PATCH v10] i2c-designware: make SDA hold time configurable
Thread-Topic: [PATCH v10] i2c-designware: make SDA hold time configurable
Thread-Index: AQHOd/vSFjLsCch5gEWb62BnCFg/nZlTC9KAgAAAYxA=
Date: Wed, 3 Jul 2013 15:07:19 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF379F0@039-SN2MPN1-011.039d.mgd.msft.net>
References: <20130625163902.GA2973@katana> <20130703143835.GD3929@ab42.lan>
 <201307031642.30380.arnd@arndb.de> <201307031644.09669.arnd@arndb.de>
 <20130703145918.GE3929@ab42.lan>
In-Reply-To: <20130703145918.GE3929@ab42.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.137.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Christian Ruppert [mailto:christian.ruppert@abilis.com]
(..)
> Although this doesn't explicitly state what the function returns to me
> this sounds more like the quotient is returned rather than the remainder?

Hi,

Yes div_u64() returns the quotient.

It is defined in linux/math64.h as:

  static inline u64 div_u64(u64 dividend, u32 divisor)
  {
          u32 remainder;
          return div_u64_rem(dividend, divisor, &remainder);
  }

The remainder is probably fully optimized out.

Best regards,

V.


