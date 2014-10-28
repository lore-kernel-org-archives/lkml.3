Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbaJ1Iu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:50:57 -0400
Received: from mail-bn1bon0142.outbound.protection.outlook.com ([157.56.111.142]:31649
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755233AbaJ1Iuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:50:51 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "dave.hansen@intel.com" <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: Does slow_virt_to_phys() work with vmalloc() in the case of
 32bit-PAE and 2MB page?
Thread-Topic: Does slow_virt_to_phys() work with vmalloc() in the case of
 32bit-PAE and 2MB page?
Thread-Index: Ac/yfEPZo4Dur33tTNaXzR8m0tIt+QAD4M0A
Date: Tue, 28 Oct 2014 08:50:34 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C610568754@HKNPRD3002MB017.064d.mgd.msft.net>
References: <F792CF86EFE20D4AB8064279AFBA51C610567A76@HKNPRD3002MB017.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C610567A76@HKNPRD3002MB017.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(164054003)(377454003)(53754006)(13464003)(189002)(51704005)(199003)(2501002)(95666004)(4396001)(86612001)(46406003)(99396003)(55846006)(97736003)(76482002)(20776003)(47776003)(120916001)(77096002)(81156004)(107046002)(106466001)(64706001)(84676001)(19580405001)(97756001)(85852003)(86362001)(92566001)(16796002)(31966008)(92726001)(68736004)(19580395003)(86146001)(69596002)(44976005)(33656002)(6806004)(50986999)(26826002)(66066001)(54356999)(23726002)(85306004)(76176999)(80022003)(2656002)(87936001)(21056001)(46102003)(50466002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1202;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1202;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On
> Behalf Of Dexuan Cui
> Sent: Tuesday, October 28, 2014 15:08 PM
> To: Dave Hansen; Rik van Riel; H. Peter Anvin
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org
> Subject: Does slow_virt_to_phys() work with vmalloc() in the case of 32bit-
> PAE and 2MB page?
> 
> Hi all,
> I suspect slow_virt_to_phys() may not work with vmalloc() in
> the 32-bit PAE case(when the pa > 4GB), probably due to 2MB page(?)
> 
> Is there any known issue with slow_virt_to_phys() + vmalloc() +
> 32-bit PAE + 2MB page?
> 
> From what I read the code of slow_virt_to_phys(), the variable 'psize' is
> assigned with a value but not used at all -- is this a bug?
After reading through the code, I think there is no issue here, though the
assignment of 'psize'  should be unnecessary, I think.
 
Thanks,
-- Dexuan

