Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965559AbaFRJB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:01:29 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36700 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964781AbaFRJBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:01:25 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Dave Jones'" <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ganesanr@broadcom.com" <ganesanr@broadcom.com>
Subject: RE: MIPS: Add MSI support for XLP9XX
Thread-Topic: MIPS: Add MSI support for XLP9XX
Thread-Index: AQHPiorONqr19seX7kWrjoav1rjBM5t2kdzg
Date: Wed, 18 Jun 2014 09:00:08 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725E5A8@AcuExch.aculab.com>
References: <20140610013104.DF5A8660F61@gitolite.kernel.org>
 <20140618001837.GA24753@redhat.com>
In-Reply-To: <20140618001837.GA24753@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones
> On Tue, Jun 10, 2014 at 01:31:04AM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=d66f3f0e10b49df8d0cc0d8eb5bf2ef9863a33cf
>  > Commit:     d66f3f0e10b49df8d0cc0d8eb5bf2ef9863a33cf
>  > Parent:     1c98398662c9b4e2f03f64344f83dd6cb14e0420
>  > Refname:    refs/heads/master
>  > Author:     Ganesan Ramalingam <ganesanr@broadcom.com>
>  > AuthorDate: Fri May 9 16:35:49 2014 +0530
>  > Committer:  Ralf Baechle <ralf@linux-mips.org>
>  > CommitDate: Fri May 30 16:51:02 2014 +0200
>  >
>  >     MIPS: Add MSI support for XLP9XX
> 
> ...
> 
>  > +		if (cpu_is_xlp9xx()) {
>  > +			val = ((node * nlm_threads_per_node()) << 7 |
>  > +				PIC_PCIE_MSIX_IRQ(link) << 1 | 0 << 0);
> 
> Should this be..
> 
> 			val = ((node * nlm_threads_per_node()) << 7 |
> 				PIC_PCIE_MSIX_IRQ(link) << 1);
> 			val &= ~(1 << 0);
> 
> perhaps ? because shifting a zero is a nop, as is ORing it.

Unlikely, it looks to me as though it is just being explicit that the
low bit of the compound word (whatever it is) is zero.

	David



