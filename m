Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaC1UyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:54:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:20787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbaC1UyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:54:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,752,1389772800"; 
   d="scan'208";a="501910329"
From: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
To: Madoka Komatsubara <m-komatsubara@ab.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Hiroshi Baba <h-baba@ax.jp.nec.com>
Subject: RE: Unable to receive multicast packet on VF
Thread-Topic: Unable to receive multicast packet on VF
Thread-Index: Ac9KeKSflRJoEdc0T8ah/zzTQlagLwARBM0w
Date: Fri, 28 Mar 2014 20:54:14 +0000
Message-ID: <F6FB0E698C9B3143BDF729DF2228664685D9725C@ORSMSX110.amr.corp.intel.com>
References: <9DE5760509B7974286F38D93BF31DD62C7D0B8@BPXM13GP.gisp.nec.co.jp>
In-Reply-To: <9DE5760509B7974286F38D93BF31DD62C7D0B8@BPXM13GP.gisp.nec.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Madoka Komatsubara [mailto:m-komatsubara@ab.jp.nec.com]
> Sent: Friday, March 28, 2014 4:49 AM
> To: linux-kernel@vger.kernel.org; e1000-devel@lists.sourceforge.net;
> netdev@vger.kernel.org
> Cc: Hiroshi Shimamoto; Hiroshi Baba
> Subject: [E1000-devel] Unable to receive multicast packet on VF
> 
> Hi all,
> 
> 
> We would like to use multicast packet on the guest with Intel 82599EB SR-
> IOV.
> However, the document says that adding the multicast MAC address to the
> VF is allowed during PF initialization only. (Please refer to the URL below.) It
> means that we couldn't handle dynamically allocated multicast address.
> 
> On the other hand,
> >From the data sheet, 82599EB has Multicast Promiscuous mode.
> We could enable it on PF and all multicast packets are delivered to every VF.
> That doesn't seem good, because each guest has to handle unnecessary
> packet.
> 
> Isn't it good to have a feature to add specific multicast address to VF?
> Does anyone know that issue or the solution?
> 
> 
> 
> <http://www.intel.com/content/dam/www/public/us/en/documents/datas
> heets/82599-10-gbe-controller-datasheet.pdf>
>  page585
>  section 8.2.3.7.7
>  "This table should be initialized by software before transmit and receive are
> enabled."
> 
> Regards,
> Madoka Komatsubara
> 

Hi Madoka,

You can see where we are changing the multicast address list in the VF driver in ixgbevf_set_rx_mode().  This not only called via ndo_set_rx_mode but in our up and open calls.   So while it is true this needs to be initialized before transmit and receive are enabled, the value can be changed without requiring the module to be reloaded.

Hope that helps,
-Don
