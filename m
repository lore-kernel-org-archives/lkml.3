Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbbA2Buv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:50:51 -0500
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:49932
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758741AbbA2Bus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:50:48 -0500
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH RESEND 1/8] Drivers: hv: vmbus: prevent cpu offlining on
 newer hypervisors
Thread-Topic: [PATCH RESEND 1/8] Drivers: hv: vmbus: prevent cpu offlining on
 newer hypervisors
Thread-Index: AQHQOoFLg5C1PLhtaESsPtAifDH0apzWGc2g
Date: Wed, 28 Jan 2015 22:16:56 +0000
Message-ID: <BY2PR0301MB071150CF1FC27F35ABC75702A0330@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1422402376-5463-1-git-send-email-kys@microsoft.com>
 <1422402408-5504-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1422402408-5504-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:c5bd:6f32:8b0b:8e37]
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0712;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-forefront-prvs: 047001DADA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(377454003)(2656002)(87936001)(122556002)(54206007)(86362001)(50986999)(76176999)(54606007)(54356999)(2201001)(40100003)(77156002)(62966003)(102836002)(2950100001)(2900100001)(33656002)(99286002)(74316001)(107886001)(76576001)(86612001)(2501002)(46102003)(19580395003)(19580405001)(106116001)(1511001)(92566002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2015 22:16:56.6183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0712
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, January 27, 2015 3:47 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> vkuznets@redhat.com; tglx@linutronix.de
> Cc: KY Srinivasan
> Subject: [PATCH RESEND 1/8] Drivers: hv: vmbus: prevent cpu offlining on
> newer hypervisors
> 
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> When an SMP Hyper-V guest is running on top of 2012R2 Server and
> secondary cpus are sent offline (with echo 0 >
> /sys/devices/system/cpu/cpu$cpu/online)
> the system freeze is observed. This happens due to the fact that on newer
> hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are distributed
> across all cpus (see init_vp_index() function in drivers/hv/channel_mgmt.c)
> and on cpu offlining nobody reassigns them to CPU0. Prevent cpu offlining
> when vmbus is loaded until the issue is fixed host-side.
> 
> This patch also disables hibernation but it is OK as it is also broken (MCE error
> is hit on resume). Suspend still works.
> 
> Tested with WS2008R2 and WS2012R2.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Greg,

Please drop this entire series; the patch-set was based on the incorrect tree. I will resend the set shortly
after rebasing them on your  char-misc.git.

Thank you,

K. Y
