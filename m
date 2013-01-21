Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3AUVrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:47:39 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:52901
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab3AUVri convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:47:38 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Id6eah542Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MGZWJ4-02-46V-02
X-M-MSG: 
From: "Kinney, Steven" <Steven.Kinney@amd.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>
Subject: RE: [PATCH 2/3] AMD IOMMUv2 PC resource management hooks
Thread-Topic: [PATCH 2/3] AMD IOMMUv2 PC resource management hooks
Thread-Index: AQHN+BTe2RleD7oETU2JWWt2TEs+9ZhUsf4A//+fDOA=
Date: Mon, 21 Jan 2013 21:47:30 +0000
Message-ID: <57D41218901B4442B4AFF404D21591163B9FAD@sausexdag02.amd.com>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
 <1358799658-6236-3-git-send-email-steven.kinney@amd.com>
 <20130121213218.GI25252@moon>
In-Reply-To: <20130121213218.GI25252@moon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.70.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

                 Agree, will clean this up.

Thanks

-----Original Message-----
From: Cyrill Gorcunov [mailto:gorcunov@gmail.com] On Behalf Of Cyrill Gorcunov
Sent: Monday, January 21, 2013 3:32 PM
To: Kinney, Steven
Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org; Joerg Roedel; Bjorn Helgaas; Greg Kroah-Hartman; Sebastian Andrzej Siewior; Myron Stowe; Hiroshi DOYU; Stephen Warren; Jiri Kosina; Kukjin Kim; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org; Peter Zijlstra; Paul Mackerras; Arnaldo Carvalho de Melo; Thomas Renninger; Andi Kleen
Subject: Re: [PATCH 2/3] AMD IOMMUv2 PC resource management hooks

On Mon, Jan 21, 2013 at 02:20:57PM -0600, Steven L. Kinney wrote:
> +u8 amd_iommu_v2_get_max_pc_banks(u16 devid) {
> +	struct amd_iommu *iommu;
> +
> +	/* locate the iommu governing the devid */
> +	iommu = amd_iommu_rlookup_table[devid];
> +
> +	if (iommu)
> +		return iommu->max_banks;
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL(amd_iommu_v2_get_max_pc_banks);

Hi Steven, may not it be better to return int here, instead of u8?


