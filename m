Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbaLKAH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:07:29 -0500
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:54496
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758309AbaLKAH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:07:27 -0500
Message-ID: <1418256437.5581.51.camel@freescale.com>
Subject: Re: [PATCH 2/4] powerpc32: properly clear page table when 0 is not
 a good default PTE value
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 10 Dec 2014 18:07:17 -0600
In-Reply-To: <20141210180037.C46001A5D62@localhost.localdomain>
References: <20141210180037.C46001A5D62@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR02CA0052.namprd02.prod.outlook.com (10.141.56.52) To
 BN1PR0301MB0723.namprd03.prod.outlook.com (25.160.78.142)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0723;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0723;
X-Forefront-PRVS: 0422860ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(377424004)(189002)(199003)(105586002)(97736003)(106356001)(107046002)(62966003)(77156002)(110136001)(4396001)(46102003)(50466002)(36756003)(50226001)(68736005)(40100003)(122386002)(21056001)(23676002)(101416001)(33646002)(103116003)(31966008)(99396003)(87976001)(47776003)(120916001)(50986999)(20776003)(42186005)(76176999)(86362001)(89996001)(64706001)(92566001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0723;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0723;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 19:00 +0100, Christophe Leroy wrote:
> Some HW invert some PTE bits. In some case, __pte(0) is not 0 so the PTEs shall
> be properly set prior to being used.

__pte(0) is always zero.  If that changes in a future patch, that patch
is not doing the right thing.  The __pte()/pte_val() accesors should not
do anything beyond boxing/unboxing the value in a struct.  The right
place for special 8xx handling of the inverted bit is in pte_mkwrite()
and such.

I don't see any other architecture using __pte()/pte_val() this way.

-Scott


