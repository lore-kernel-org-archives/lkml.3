Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaH2Otf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:49:35 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:25080
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752528AbaH2Otd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:49:33 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPw26QHOqdouoVV0yV/yTpMU6fvpvnW6KAgAAT8UCAADe1UA==
Date: Fri, 29 Aug 2014 14:48:25 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C997A1DB@SINEX14MBXC418.southpacific.corp.microsoft.com>
References: <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827161900.GA25326@sucs.org>
 <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140829094945.GA5122@mwanda>
 <EE124450C0AAF944A40DD71E61F878C997956C@SINEX14MBXC418.southpacific.corp.microsoft.com>
 <20140829102411.GE5071@mwanda> <20140829112009.GD11445@sucs.org>
In-Reply-To: <20140829112009.GD11445@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(189002)(199003)(13464003)(377454003)(51704005)(21056001)(95666004)(106116001)(80022001)(106466001)(81156004)(23726002)(107046002)(81542001)(81342001)(86612001)(77096002)(46102001)(55846006)(83322001)(76482001)(46406003)(15975445006)(90102001)(33656002)(19580395003)(2656002)(84676001)(85306004)(69596002)(68736004)(93886004)(20776003)(77982001)(64706001)(97736001)(15395725005)(97756001)(47776003)(79102001)(44976005)(6806004)(26826002)(92726001)(99396002)(16796002)(92566001)(31966008)(74662001)(74502001)(76176999)(85852003)(4396001)(83072002)(15202345003)(86362001)(50466002)(50986999)(54356999)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0767;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler
> Sent: Friday, August 29, 2014 19:20 PM
> Because this particular return code is overloaded with multiple meanings
> that can't necessarily be deduced from its name perhaps this
> documentation patch would be helpful:
> 
> diff --git a/arch/x86/include/uapi/asm/hyperv.h
> b/arch/x86/include/uapi/asm/hyperv.h
> index 462efe7..04894d5 100644
> --- a/arch/x86/include/uapi/asm/hyperv.h
> +++ b/arch/x86/include/uapi/asm/hyperv.h
> @@ -213,6 +213,12 @@
>  #define HV_STATUS_SUCCESS                      0
>  #define HV_STATUS_INVALID_HYPERCALL_CODE       2
>  #define HV_STATUS_INVALID_HYPERCALL_INPUT      3
> +/*
> + * HV_STATUS_INVALID_ALIGNMENT indicates one of the following:
> + *   The input or output pointer is not aligned to 8 bytes.
> + *   The input or output lists span more than one page.
> + *   The input or output pointer is out of bounds.
> + */
>  #define HV_STATUS_INVALID_ALIGNMENT            4
>  #define HV_STATUS_INSUFFICIENT_BUFFERS         19
> 
> Dexuan: Does this mean that if input/output pointer is well aligned and
> the (payload start) is in the same page as (payload start + payload
> size) all will be well? If so it won't matter what the length of payload
> size is right?
> 
> --
> Sitsofe | http://sucs.org/~sits/

Hi Sitsofe,
I personally think so, but I'm not 100% sure about the exact behavior of
the hypervisor here:
my previous patch tried to only use page-aligned-allocation when
payload_start and payload_end are not on the same page, but I still got
the "invalid alignment" error code occasionally, which makes me a little
upset, honestly speaking. 

Thanks,
-- Dexuan
