Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3CTVSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:18:48 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:5664
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab3CTVSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:18:46 -0400
X-Greylist: delayed 16147 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 17:18:46 EDT
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Thread-Topic: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Thread-Index: AQHOJCAqmvU0usyXI0yxxCAslUbX+ZiscZuAgAJZ0ICAAAIXAIAAFDYAgAADCQCAABG+AIAAFsMAgAAJaYCAAAHrgA==
Date: Wed, 20 Mar 2013 21:18:10 +0000
Message-ID: <1363814289.2553.41.camel@x230.sbx07502.somerma.wayport.net>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
	 <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
	 <1363797717.2580.10.camel@falcor1.watson.ibm.com>
	 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
	 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
	 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
	 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
	 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
	 <1363813877.2580.120.camel@falcor1.watson.ibm.com>
In-Reply-To: <1363813877.2580.120.camel@falcor1.watson.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9835E61BBA08494EBCDF231A480EE45B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2KLIoNf002646

On Wed, 2013-03-20 at 17:11 -0400, Mimi Zohar wrote:
> On Wed, 2013-03-20 at 20:37 +0000, Matthew Garrett wrote:
> > Right, that'd be the rough idea. Any further runtime policy updates
> > would presumably need to be signed with a trusted key.
> 
> I'm really sorry to belabor this point, but can kexec rely on an LSM
> label to identify a specific file, out of all the files being executed,
> in a secure boot environment?  The SELinux integrity rule for kexec
> would then look something like,
>
> appraise func=BPRM_CHECK obj_type=kdump_exec_t appraise_type=imasig

It would certainly be possible to configure a system such that this was
true (assuming support for signed initramfs and restricted policy
loading), and anyone wanting to ensure that kexec only loaded trusted
binaries would have to ensure that their system was appropriately
configured. Having some mechanism to then give the kexec binary
CAP_MODIFY_KERNEL would avoid needing an extra kexec entry point.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
