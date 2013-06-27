Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3F0Sjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:39:44 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:3857 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab3F0Sjl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:39:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Thu, 27 Jun 2013 13:39:23 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: <linuxppc-dev@lists.ozlabs.org>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm-ppc@vger.kernel.org>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
	<1372309356-28320-9-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1372309356-28320-9-git-send-email-aik@ozlabs.ru> (from
	aik@ozlabs.ru on Thu Jun 27 00:02:36 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1372358363.8183.53@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 12:02:36 AM, Alexey Kardashevskiy wrote:
> +/*
> + * The KVM guest can be backed with 16MB pages.
> + * In this case, we cannot do page counting from the real mode
> + * as the compound pages are used - they are linked in a list
> + * with pointers as virtual addresses which are inaccessible
> + * in real mode.
> + *
> + * The code below keeps a 16MB pages list and uses page struct
> + * in real mode if it is already locked in RAM and inserted into
> + * the list or switches to the virtual mode where it can be
> + * handled in a usual manner.
> + */
> +#define KVMPPC_HUGEPAGE_HASH(gpa)	hash_32(gpa >> 24, 32)
> +
> +struct kvmppc_iommu_hugepage {
> +	struct hlist_node hash_node;
> +	unsigned long gpa;	/* Guest physical address */
> +	unsigned long hpa;	/* Host physical address */
> +	struct page *page;	/* page struct of the very first  
> subpage */
> +	unsigned long size;	/* Huge page size (always 16MB at the  
> moment) */
> +};

Shouldn't this be namespaced to something like "book3s" or "spapr"?

-Scott
