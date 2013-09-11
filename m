Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3IKUDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:03:12 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:16863
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753710Ab3IKUDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:03:11 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, Haiyang Zhang <haiyangz@microsoft.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: vmbus: fix error return code in
 vmbus_connect()
Thread-Topic: [PATCH] Drivers: hv: vmbus: fix error return code in
 vmbus_connect()
Thread-Index: AQHOruDXfDzmhxyj6EW2aZqcUVuzqJnA9YdQ
Date: Wed, 11 Sep 2013 20:03:07 +0000
Message-ID: <7463564f181640d2ad9658ce0ef7a7b5@SN2PR03MB061.namprd03.prod.outlook.com>
References: <CAPgLHd-5dt70Tn+3SXXu9QudpwpHaO1FNf-LZWQmDq413KLbQg@mail.gmail.com>
In-Reply-To: <CAPgLHd-5dt70Tn+3SXXu9QudpwpHaO1FNf-LZWQmDq413KLbQg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::5]
x-forefront-prvs: 09669DB681
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(199002)(189002)(377454003)(13464003)(51856001)(31966008)(74662001)(80022001)(46102001)(19580405001)(19580395003)(83322001)(47446002)(33646001)(83072001)(74502001)(53806001)(74706001)(74876001)(81342001)(81542001)(69226001)(4396001)(56776001)(76482001)(54316002)(47736001)(47976001)(49866001)(63696002)(76576001)(77982001)(50986001)(56816003)(81816001)(77096001)(80976001)(76796001)(76786001)(59766001)(81686001)(65816001)(74366001)(74316001)(1511001)(54356001)(79102001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ed43::5;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> Sent: Wednesday, September 11, 2013 4:20 AM
> To: KY Srinivasan; Haiyang Zhang
> Cc: yongjun_wei@trendmicro.com.cn; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] Drivers: hv: vmbus: fix error return code in vmbus_connect()
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -EINVAL in the version check error handling
> case instead of 0, as done elsewhere in this function.

The return will not be zero in this case. If you look at the function 
vmbus_negotiate_version(), in case the host refuses the version, the
return value will be set to -ECONNREFUSED

Regards,

K. Y
