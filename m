Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaDWRyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:54:13 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:47825
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752302AbaDWRyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:54:11 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 0/2] Eliminate spin locks in the vmbus channel callback
 path 
Thread-Topic: [PATCH 0/2] Eliminate spin locks in the vmbus channel callback
 path 
Thread-Index: AQHPU43HUwoZP4LED0ePzBPBp6g6VZsfkqrA
Date: Wed, 23 Apr 2014 17:54:08 +0000
Message-ID: <3d9592625f174cdfadd4bab4b10d4ff9@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1397007928-13555-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1397007928-13555-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(13464003)(377454003)(51704005)(77096999)(76176999)(50986999)(76576001)(54356999)(99286001)(19580405001)(83322001)(76482001)(74662001)(74502001)(31966008)(80022001)(74316001)(20776003)(87936001)(79102001)(2656002)(1511001)(81542001)(83072002)(19580395003)(81342001)(80976001)(33646001)(4396001)(85852003)(92566001)(2201001)(99396002)(86362001)(77982001)(46102001)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:B85EFDC3.910C4D0F.B9740F8F.44F4097A.2024A;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, April 8, 2014 6:45 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH 0/2] Eliminate spin locks in the vmbus channel callback path
> 
> Currently we map the channel handle to the channel under the protection of
> a spin lock. Additionally, we dispatch the channel callback function under the
> protection of the channel inbound lock (another spin lock). In some recent
> nework performance runs, the time spent acquiring and releasing these locks
> were identified as potential bottlenecks. This patch-set gets rid of these locks
> by leveraging the interrupt bindings that we support starting with win8.
> 
> K. Y. Srinivasan (2):
>   Drivers: hv: Eliminate the channel spinlock in the callback path
>   Drivers: hv: vmbus: Implement per-CPU mapping of relid to channel
> 
>  drivers/hv/channel.c      |   16 ++++++++++---
>  drivers/hv/channel_mgmt.c |   52
> ++++++++++++++++++++++++++++++++++++++++----
>  drivers/hv/connection.c   |   35 +++++++++++++++++++++++-------
>  drivers/hv/hv.c           |    2 +
>  drivers/hv/hyperv_vmbus.h |    5 ++++
>  include/linux/hyperv.h    |    7 ++++++
>  6 files changed, 100 insertions(+), 17 deletions(-)
> 
> --
> 1.7.4.1

Greg,

Should I resend this patch set.

K. Y
