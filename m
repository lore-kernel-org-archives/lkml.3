Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbaDWPOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:14:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:23139 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbaDWPOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="498108766"
Date: Wed, 23 Apr 2014 11:13:04 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Dimitri John Ledkov <dimitri.ledkov@surgut.co.uk>
Cc: linux-nvme@lists.infradead.org, keith.busch@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NVMe: Update namespace and controller identity
 structures as per 1.1a spec
Message-ID: <20140423151304.GF13050@linux.intel.com>
References: <1397942397-29998-1-git-send-email-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397942397-29998-1-git-send-email-dimitri.ledkov@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 10:19:57PM +0100, Dimitri John Ledkov wrote:
> Controller: add CNTLID, AVSCC, APSTA, NVSCC, ACWU, SGLS fields.
> 
> Namespace: add NMIC, RESCAP, EUI64 fields. EUI64 is specifically
> interesting, since it can be used to construct an UEFI NVMe device
> path for a boot entry.
> 
> As per NVM Express 1.1a spec:
> http://www.nvmexpress.org/wp-content/uploads/NVM-Express-1_1a.pdf

Thanks for the patch!

> -	__u8			rsvd78[178];
> +	__le16			cntlid;
> +	__u8			rsvd80[176];

I don't think cntlid is a little-endian value.  I think it's a cookie,
so this should be __u16.

> -	__u8			rsvd30[98];
> +	__u8			nmic;
> +	__u8			rescap;
> +	__u8			rsvd32[88];
> +	__le64			eui64;

eui64 isn't treated as a 64-bit value elsewhere in the kernel, rather as
an array of bytes.  So I think this one should be:

	__u8			eui64[8];

That matches the IEEE's recommendations:

An EUI-64 is a string of eight octets, labeled as eui[0] through eui[7].

(see http://standards.ieee.org/develop/regauth/tut/eui64.pdf)
