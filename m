Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbbA1WBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:01:05 -0500
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:42439
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757190AbbA1UYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:24:36 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: RE: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
 offer
Thread-Topic: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
 offer
Thread-Index: AQHQOvMvpKTJmOaTDEmNPuquIq7yQJzVecfA
Date: Wed, 28 Jan 2015 12:51:42 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C61EA9510B@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
	<1421768706-5363-4-git-send-email-vkuznets@redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C61EA94FB7@SIXPRD3002MB028.064d.mgd.msft.net>
 <8761br9kfd.fsf@vitty.brq.redhat.com>
In-Reply-To: <8761br9kfd.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.69]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 206.191.229.84)
 smtp.mailfrom=decui@microsoft.com; oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=pass action=none header.from=microsoft.com;
X-Forefront-Antispam-Report: CIP:206.191.229.84;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(377454003)(51704005)(47776003)(106466001)(106116001)(62966003)(77156002)(110136001)(46102003)(33656002)(66066001)(55846006)(86362001)(22746005)(87936001)(86612001)(23676002)(19580405001)(19580395003)(6806004)(92566002)(22756005)(2900100001)(102836002)(2656002)(2920100001)(104016003)(2950100001)(50466002)(93886004)(54356999)(86146001)(50986999)(76176999)(79686002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0848;H:064-smtp-out.microsoft.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-DmarcStatus-Test: Passed
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004)(3003004);SRVR:DM2PR0301MB0848;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0848;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0848;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 12:51:51.0873
 (UTC)
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=72f988bf-86f1-41af-91ab-2d7cd011db47;Ip=[206.191.229.84]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SM1COB007680

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Wednesday, January 28, 2015 20:09 PM
> To: Dexuan Cui
> Cc: KY Srinivasan; devel@linuxdriverproject.org; Haiyang Zhang; linux-
> kernel@vger.kernel.org; Jason Wang; Radim KrÄmÃ¡Å™; Dan Carpenter
> Subject: Re: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
> offer
> 
> Dexuan Cui <decui@microsoft.com> writes:
> 
> >> -----Original Message-----
> >> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> >> Sent: Tuesday, January 20, 2015 23:45 PM
> >> To: KY Srinivasan; devel@linuxdriverproject.org
> >> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Jason Wang;
> >> Radim KrÄmÃ¡Å™; Dan Carpenter
> >> Subject: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
> offer
> ...
> >
> > Hi Vitaly and all,
> > I have 2 questions:
> > In vmbus_process_offer(),  in the cases of "goto err_free_chan",
> > should we consider the possibility a rescind message could be pending for
> > the new channel?
> > In the cases,  because we don't run
> > "INIT_WORK(&newchannel->work, vmbus_process_rescind_offer); ",
> > vmbus_onoffer_rescind() will do nothing and as a result,
> > vmbus_process_rescind_offer() won't be invoked.
> 
> Yes, but processing the rescind offer results in freeing the channel
> (and this processing supposes the channel wasn't freed before) so
> there is no difference... or is it?
> 
> >
> > Question 2: in vmbus_process_offer(), in the case
> > vmbus_device_register() fails, we'll run
> > "list_del(&newchannel->listentry);" -- just after this line,
> >  what will happen at this time if relid2channel() returns NULL
> > in vmbus_onoffer_rescind()?
> >
> > I think we'll lose the rescind message.
> >
> 
> Yes, but same logic applies - we already freed the channes so no rescind
> proccessing required.
free_channel() and vmbus_process_rescind_offer() are different, because
 the latter does more work, e.g., sending the host a message 
CHANNELMSG_RELID_RELEASED.

In the cases of "goto err_free_chan" + "a pending rescind message",
the host may expect the message CHANNELMSG_RELID_RELEASED and
could reoffer the channel once the message is received.

It would be better if the VM doesn't lose the rescind message here. :-)

>  If we still need to do something we need to
> add support for already freed channel to the rescind offer processing path.
> 

Thanks,
-- Dexuan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
