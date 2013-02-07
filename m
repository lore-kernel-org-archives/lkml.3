Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3BGMoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:44:12 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.24]:55948
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936Ab3BGMoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:44:08 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -12
X-BigFish: PS-12(zz9371I1403R542I1432I4015Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Florian Westphal <fw@strlen.de>, Feng Hong <hongfeng@marvell.com>
CC: "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: Regression, bisected: hyperv shutdown panics guest
Thread-Topic: Regression, bisected: hyperv shutdown panics guest
Thread-Index: AQHOBSGbHWF1ardsw0y2B1KsficUU5huVnRQ
Date: Thu, 7 Feb 2013 12:43:27 +0000
Message-ID: <fde89baf47fb4e44af86c784a4fafe91@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130207105415.GD13962@breakpoint.cc>
In-Reply-To: <20130207105415.GD13962@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CHROMIUM.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%XMISSION.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%STRLEN.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%MARVELL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(13464002)(189002)(199002)(164054002)(51704002)(51234001)(23726001)(63696002)(5343635001)(4396001)(79102001)(20776003)(53806001)(54356001)(56776001)(59766001)(77982001)(47776003)(56816002)(44976002)(51856001)(74502001)(33646001)(47446002)(74662001)(54316002)(49866001)(76482001)(50986001)(47976001)(47736001)(31966008)(80022001)(50466001)(65816001)(46102001)(16676001)(6806001)(46406002)(66066001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB036;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0750463DC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Florian Westphal [mailto:fw@strlen.de]
> Sent: Thursday, February 07, 2013 5:54 AM
> To: Feng Hong
> Cc: ebiederm@xmission.com; Kees Cook; linux-kernel@vger.kernel.org; KY
> Srinivasan; Haiyang Zhang
> Subject: Regression, bisected: hyperv shutdown panics guest
> 
> With 3.7, hyperv guest shutdown no longer works.
> Instead, guest kernel throws a bunch of "BUG: scheduling-while-atomic"
> errors and then dies.
> 
> reverting
> 
> commit 6c0c0d4d1080840eabb3d055d2fd81911111c5fd
> Author: hongfeng <hongfeng@marvell.com>
> Date:   Thu Oct 4 17:12:25 2012 -0700
> poweroff: fix bug in orderly_poweroff()
> 
> fixes this problem.
> 
> Greping for users of orderly_poweroff() shows that hyperv isn't
> the only caller that invokes the function from irq context.
> 
> In fact, kdoc for orderly_poweroff says:
> 
> * This may be called from any context to trigger a system shutdown.
> * If the orderly shutdown fails, it will force an immediate shutdown.
> 
> Any suggestions on how to properly fix this?
> 
> Thanks,
> Florian
> 

A patch has been submitted to fix this problem. It is in Greg's queue:
Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context


Regards,

K. Y

