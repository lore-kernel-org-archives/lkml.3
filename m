Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaABLiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:38:22 -0500
Received: from smtp.citrix.com ([66.165.176.89]:26152 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaABLiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:38:21 -0500
X-IronPort-AV: E=Sophos;i="4.95,590,1384300800"; 
   d="scan'208";a="89193547"
Message-ID: <52C54FAA.4030206@citrix.com>
Date: Thu, 2 Jan 2014 11:38:18 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 12/18] xen/grants: Remove gnttab_max_grant_frames
 dependency on gnttab_init.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-13-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-13-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> The function gnttab_max_grant_frames() returns the maximum amount
> of frames (pages) of grants we can have. Unfortunatly it was
> dependent on gnttab_init() having been run before to initialize
> the boot max value (boot_max_nr_grant_frames).
> 
> This meant that users of gnttab_max_grant_frames would always
> get a zero value if they called before gnttab_init() - such as
> 'platform_pci_init' (drivers/xen/platform-pci.c).
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

You can pull this out of the PVH series and merge early if you prefer.

David
