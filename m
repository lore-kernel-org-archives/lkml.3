Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaLEKnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:43:16 -0500
Received: from smtp.citrix.com ([66.165.176.89]:24327 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaLEKnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:43:15 -0500
X-IronPort-AV: E=Sophos;i="5.07,521,1413244800"; 
   d="scan'208";a="200280696"
Message-ID: <54818C40.5020706@citrix.com>
Date: Fri, 5 Dec 2014 10:43:12 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: fix sparse warning in p2m.c
References: <1417760195-16911-1-git-send-email-jgross@suse.com>
In-Reply-To: <1417760195-16911-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 06:16, Juergen Gross wrote:
> The patch "Speed up set_phys_to_machine() by using read-only mappings"
> introduced a sparse warning:
> 
> arch/x86/xen/p2m.c:628:13: sparse: incorrect type in argument 1
>                            (different address spaces)
> 
> Avoid the warning.

Thanks.

But can you add some helper functions instead?  Perhaps:

static inline int xen_safe_write_ulong(unsigned long *addr,
    unsigned long val)
{
    //...
}

static inline int xen_safe_read_ulong(unsigned long *addr,
        unsigned long *val)
{
    //...
}

David
