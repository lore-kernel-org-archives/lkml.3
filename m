Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaB0Uwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:52:30 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:40019 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaB0Uw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:52:29 -0500
Message-ID: <530FA586.3010400@de.ibm.com>
Date: Thu, 27 Feb 2014 21:52:22 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vlad Yasevich <vyasevic@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: macvtap performance regression (bisected) between 3.13 and 3.14-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022720-8372-0000-0000-000008D34EDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad,

commit 6acf54f1cf0a6747bac9fea26f34cfc5a9029523
    macvtap: Add support of packet capture on macvtap device.

causes a performance regression for iperf traffic between two KVM guests
on my s390 system. Both guests are connected via two macvtaps on the same OSA
network card.
Before that patch I get ~20 Gbit/sec between two guests, afterwards I get
~4Gbit/sec

Latency seems to be unchanges (uperf 1byte ping pong).

According to ifconfig in the guest, I have ~ 1500 bytes per packet with this
patch and ~  40000 bytes without. So for some reason this patch causes the
network stack to do segmentation. (the guest kernel stays the same, only host 
kernel is changed).

Any ideas?


Christian

