Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3LMLh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:37:56 -0500
Received: from smtp.citrix.com ([66.165.176.89]:41956 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab3LMLhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:37:55 -0500
X-IronPort-AV: E=Sophos;i="4.95,478,1384300800"; 
   d="scan'208";a="84237995"
Message-ID: <52AAF176.3020102@citrix.com>
Date: Fri, 13 Dec 2013 11:37:26 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v10] Repost of PVH patches for Linux.
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> Hey,
> 
> Mukesh had posted them quite a while ago - they got reviewed, acked, etc,
> put in #linux-next, got patches to fix some things from folks.
> 
> Then everybody focused on the Xen patches .. and now that is mostly
> baked this is what is needed on the Linux side to make it work
> with PVH. I had them based on v3.6, then merged on v3.11, then..
> 
> Decided to rebase all of them on v3.13-rc3 to make it easier.

In general the series is a bit of mess, early patches doing things one
way (using hypercalls that no longer exist for example) and later
patches fixing things up.  I think this should be sorted out as it makes
it too difficult to review carefully (I've only given the series a
quick, initial review).

> Couple of things:
> 
> a) the patch:
>  [PATCH V10 14/14] xen/pvh: vcpu info placement, load CS selector,
> 
> could be split in three - and I think Mukesh did have a version like that.
> I can do it myself and will - it should be obvious of how it will be done.
> 
> b). Regression testing  - I ran this with a Linux kernel dom0 (32 and 64)
>     on the latest Xen hypervisor without PVH enabled. It booted all the
>     guests I had:
>     RHEL5, SLES11, SLES12, F15, F16, F17, F18, F19, OEL5, OEL6, NetBSD PV,
>     FreeBSD HVM; and also 32 and 64 PV and PVHVM combination of the same
>     kernel (and save/restore on those). Nothing broke.

That's good to know.

David
