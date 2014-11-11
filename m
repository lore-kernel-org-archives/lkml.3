Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaKKK3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:29:36 -0500
Received: from smtp.citrix.com ([66.165.176.89]:24049 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaKKK3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:29:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,360,1413244800"; 
   d="scan'208";a="190062960"
Message-ID: <5461E50C.4040309@citrix.com>
Date: Tue, 11 Nov 2014 10:29:32 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V3 3/8] xen: Delay m2p_override initialization
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-4-git-send-email-jgross@suse.com>
In-Reply-To: <1415684626-18590-4-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 05:43, Juergen Gross wrote:
> The m2p overrides are used to be able to find the local pfn for a
> foreign mfn mapped into the domain. They are used by driver backends
> having to access frontend data.
> 
> As this functionality isn't used in early boot it makes no sense to
> initialize the m2p override functions very early. It can be done
> later without doing any harm, removing the need for allocating memory
> via extend_brk().
> 
> While at it make some m2p override functions static as they are only
> used internally.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

But...

>  static struct page *m2p_find_override(unsigned long mfn)
>  {
>  	unsigned long flags;
> -	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
> +	struct list_head *bucket;
>  	struct page *p, *ret;


    if (unlikely(!m2p_overrides))
        return NULL;

Would be preferred,

David
