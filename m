Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaC1Lw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:52:56 -0400
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:64413 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaC1Lwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:52:54 -0400
From: Madoka Komatsubara <m-komatsubara@ab.jp.nec.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Hiroshi Baba <h-baba@ax.jp.nec.com>
Subject: Unable to receive multicast packet on VF
Thread-Topic: Unable to receive multicast packet on VF
Thread-Index: Ac9KeKSflRJoEdc0T8ah/zzTQlagLw==
Date: Fri, 28 Mar 2014 11:49:05 +0000
Message-ID: <9DE5760509B7974286F38D93BF31DD62C7D0B8@BPXM13GP.gisp.nec.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.205.8.69]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


We would like to use multicast packet on the guest with Intel 82599EB SR-IOV.
However, the document says that adding the multicast MAC address to the VF 
is allowed during PF initialization only. (Please refer to the URL below.)
It means that we couldn't handle dynamically allocated multicast address.

On the other hand,
>From the data sheet, 82599EB has Multicast Promiscuous mode.
We could enable it on PF and all multicast packets are delivered to every VF.
That doesn't seem good, because each guest has to handle unnecessary packet.

Isn't it good to have a feature to add specific multicast address to VF?
Does anyone know that issue or the solution?



<http://www.intel.com/content/dam/www/public/us/en/documents/datasheets/82599-10-gbe-controller-datasheet.pdf>
 page585
 section 8.2.3.7.7
 "This table should be initialized by software before transmit and receive are enabled."

Regards,
Madoka Komatsubara
