Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaKUUHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:07:07 -0500
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:53316
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752308AbaKUUHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:07:03 -0500
X-WSS-ID: 0NFENVK-07-BYS-02
X-M-MSG: 
Message-ID: <546F9B56.2010900@amd.com>
Date: Fri, 21 Nov 2014 22:06:46 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: randconfig build error with next-20141121, in drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
References: <CA+r1Zhj4+v+ggOhXm_3qz5=d8PgSDRexs1qQB9dk+KOC2TVzMA@mail.gmail.com>
In-Reply-To: <CA+r1Zhj4+v+ggOhXm_3qz5=d8PgSDRexs1qQB9dk+KOC2TVzMA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: [10.180.168.240]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(24454002)(164054003)(377454003)(479174003)(199003)(189002)(68736004)(97736003)(80316001)(92566001)(50466002)(47776003)(20776003)(44976005)(65956001)(86362001)(99396003)(64706001)(101416001)(120916001)(92726001)(102836001)(95666004)(87936001)(84676001)(83506001)(33656002)(105586002)(107886001)(107046002)(59896002)(62966003)(77156002)(31966008)(36756003)(54356999)(21056001)(64126003)(23676002)(87266999)(106466001)(50986999)(76176999)(65816999)(4396001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/21/2014 07:04 PM, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c: In function ‘kfd_doorbell_init’:
> drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c:97:2: error: implicit
> declaration of function ‘ioremap’
> [-Werror=implicit-function-declaration]
>   kfd->doorbell_kernel_ptr = ioremap(kfd->doorbell_base,
>   ^
> drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c:97:27: warning: assignment
> makes pointer from integer without a cast [enabled by default]
>   kfd->doorbell_kernel_ptr = ioremap(kfd->doorbell_base,
>                            ^
> drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c: In function ‘write_kernel_doorbell’:
> drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c:217:3: error: implicit declaration of
> function ‘writel’ [-Werror=implicit-function-declaration]
>    writel(value, db);
>    ^
> cc1: some warnings being treated as errors
> make[4]: *** [drivers/gpu/drm/amd/amdkfd/kfd_doorbell.o] Error 1
> 

Thanks, I'm now sending a patch that fixes this problem.

	Oded
