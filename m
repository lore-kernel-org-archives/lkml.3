Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab3BGLdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:33:45 -0500
Received: from 8bytes.org ([85.214.48.195]:39109 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab3BGLdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:33:44 -0500
Date: Thu, 7 Feb 2013 12:33:40 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] intel_iommu: Disable vfio and kvm interrupt assignment
 when unsafe
Message-ID: <20130207113340.GW25591@8bytes.org>
References: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Feb  7 12:33:42 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5113911622971931413707
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 07:08:24PM -0800, Andy Lutomirski wrote:
> -	if (x2apic_present)
> -		WARN(1, KERN_WARNING
> -			"Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
> -
> +	irq_remapping_is_secure = 0;
>  	return -1;
>  }

Why do you remove this warning? It seems unrelated to the rest of the
patch.


	Joerg


