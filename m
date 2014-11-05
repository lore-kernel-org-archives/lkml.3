Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaKEPpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:45:13 -0500
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:14368
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755049AbaKEPmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:42:55 -0500
X-WSS-ID: 0NEKO9Z-07-0RK-02
X-M-MSG: 
Message-ID: <545A41E1.10303@amd.com>
Date: Wed, 5 Nov 2014 09:27:29 -0600
From: Joel Schopp <joel.schopp@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Shannon Zhao <zhaoshenglong@huawei.com>,
        =?windows-1252?Q?GAUGUEY_R?= =?windows-1252?Q?=E9my_228890?= 
	<remy.gauguey@cea.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "hangaohuai@huawei.com" <hangaohuai@huawei.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "n.nikolaev@virtualopensystems.com" 
	<n.nikolaev@virtualopensystems.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>
Subject: Re: [Qemu-devel] [RFC PATCH] virtio-mmio: support for multiple irqs
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
	<5459D8E8.6060709@huawei.com>
	<022C7612790E20489F80A6F0D54B849F3B26F4F3@EXDAG0-B1.intra.cea.fr>
 <5459EA0E.8020309@huawei.com>
In-Reply-To: <5459EA0E.8020309@huawei.com>
Content-Type: text/plain; charset="windows-1252"
X-Originating-IP: [10.180.168.240]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(51704005)(479174003)(377454003)(189002)(24454002)(4396001)(50466002)(99396003)(97736003)(92726001)(47776003)(76176999)(54356999)(20776003)(64706001)(65816999)(50986999)(15975445006)(83506001)(84676001)(120916001)(46102003)(44976005)(68736004)(101416001)(87936001)(64126003)(21056001)(92566001)(23746002)(19580395003)(65956001)(65806001)(102836001)(86362001)(95666004)(53416004)(107046002)(62966003)(31966008)(36756003)(106466001)(77096003)(105586002)(93886004)(15202345003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Joel.Schopp@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/05/2014 03:12 AM, Shannon Zhao wrote:
> Hi Rémy,
>
> On 2014/11/5 16:26, GAUGUEY Rémy 228890 wrote:
>> Hi Shannon, 
>>
>>> Type of backend         bandwith(GBytes/sec)
>>> virtio-net              0.66
>>> vhost-net               1.49
>>> vhost-net with irqfd    2.01
>>>
>>> Test cmd: ./iperf -c 192.168.0.2 -P 1 -i 10 -p 5001 -f G -t 60
>> Impressive results !
>> Could you please detail your setup ? which platform are you using and which GbE controller ?
> Sorry for not telling the test scenario. This test scenario is from Host to Guest. It just
> compare the performance of different backends. I did this test on ARM64 platform.
>
> The setup was based on:
> 1)on host kvm-arm should support ioeventfd and irqfd
> 	The irqfd patch is from Eric "ARM: KVM: add irqfd support".
> 	http://www.spinics.net/lists/kvm-arm/msg11014.html
>
> 	The ioeventfd patch is reworked by me from Antonios.
> 	http://www.spinics.net/lists/kvm-arm/msg08413.html
>
> 2)qemu should enable ioeventfd support for virtio-mmio
> 	This patch is refer to Ying-Shiuan Pan and reworked for new qemu branch.
> 	https://lists.gnu.org/archive/html/qemu-devel/2014-11/msg00594.html
>
> 3)qemu should enable multiple irqs for virtio-mmio
> 	This patch isn't sent to qemu maillist as we want to check whether this is the right direction.
> 	If you want to test, I'll send it to you.
I'm not a maintainer so my opinion isn't worth a lot here, but this
seems like the right direction to me.  I'd like to see the qemu patch
(do mention the dependency on the kernel patch) on the qemu-devel
mailing list.  I think these numbers also support some of the prereqs
listed above that have gone through several iterations getting queued up
for 3.19.
