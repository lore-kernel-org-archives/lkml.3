Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaH1OYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:24:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45646 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaH1OYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:24:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,418,1406592000"; 
   d="scan'208";a="166024992"
Message-ID: <53FF3BAE.5060807@citrix.com>
Date: Thu, 28 Aug 2014 15:24:46 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V1 PATCH 2/2] PVH: set EFER.NX and EFER.SCE for
 secondary vcpus
References: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com> <1409178815-2026-3-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1409178815-2026-3-git-send-email-mukesh.rathor@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/14 23:33, Mukesh Rathor wrote:
> This patch addresses three things for a pvh secondary vcpu:

I don't understand why you have separated this into two patches.  Please
fold into one.

> Please note: We create a new glue assembly entry point because the
> secondary vcpus come up on kernel page tables that have pte.NX
> bits set. While on Intel these are ignored if EFER.NX is not set, on
> AMD a RSVD bit fault is generated.

Please try and unify the early CPU init code for boot and secondary CPUs.

Native manages to do this (secondary_startup_64 is called for boot and
secondary CPUs).

> +	/* Gather features to see if NX implemented. (no EFER.NX on intel) */

EFER.NXE does exist on Intel.

David
