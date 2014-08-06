Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaHFWdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:33:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:54601 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbaHFWc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:32:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,814,1400050800"; 
   d="scan'208";a="572771020"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: "Fujinaka, Todd" <todd.fujinaka@intel.com>
CC: "hannes@stressinduktion.org" <hannes@stressinduktion.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mathias.koehrer@etas.com" <mathias.koehrer@etas.com>
Subject: Re: [E1000-devel] PROBLEM: [x86] Running ptpd2 using an Intel
 82572EI (e1000e) leads to a kernel oops (3.12.26)
Thread-Topic: [E1000-devel] PROBLEM: [x86] Running ptpd2 using an Intel
 82572EI (e1000e) leads to a kernel oops (3.12.26)
Thread-Index: Ac+v3yzc3cSLCNWNSz2wcfBA1YE8+gBtGo2AAAzknIAADnhHAA==
Date: Wed, 6 Aug 2014 22:32:56 +0000
Message-ID: <1407364376.29652.3.camel@jekeller-desk1.amr.corp.intel.com>
References: <50f83e65cecd4882b22887858bfdf484@FE-MBX1012.de.bosch.com>
	 <1407317367.1360819.149688237.188FBBFC@webmail.messagingengine.com>
	 <9B4A1B1917080E46B64F07F2989DADD6533AC68E@ORSMSX114.amr.corp.intel.com>
In-Reply-To: <9B4A1B1917080E46B64F07F2989DADD6533AC68E@ORSMSX114.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.173.156]
Content-Type: text/plain; charset="utf-8"
Content-ID: <228CE2C8ED20CF40977538E9073499D2@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s76MX5El014282

On Wed, 2014-08-06 at 15:38 +0000, Fujinaka, Todd wrote:
> Looking at your patches on netdev, it appears that there are flags set in the skb that should never be set for the 82572EI as that part doesn't have hardware timestamping. This points to a bug in the ptpd code.
> 
> Todd Fujinaka
> Software Application Engineer
> Networking Division (ND)
> Intel Corporation
> todd.fujinaka@intel.com
> (503) 712-4565


Surely we can bail here instead of generating a kernel oops? Even though
ptpd may be incorrect here, we still shouldn't do this. I think this may
be a bug in the set_ts_config possibly as well (since it shouldn't be
able to set the hardware timestamp flags for the 82572EI

Thanks,
Jake
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
