Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaABLkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:40:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:62105 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaABLkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:40:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,590,1384300800"; 
   d="scan'208";a="87004693"
Message-ID: <52C5500E.5010303@citrix.com>
Date: Thu, 2 Jan 2014 11:39:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 13/18] xen/grant-table: Refactor gnttab_init
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-14-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-14-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> We have this odd scenario of where for PV paths we take a shortcut
> but for the HVM paths we first ioremap xen_hvm_resume_frames, then
> assign it to gnttab_shared.addr. This is needed because gnttab_map
> uses gnttab_shared.addr.
> 
> Instead of having:
> 	if (pv)
> 		return gnttab_map
> 	if (hvm)
> 		...
> 
> 	gnttab_map
> 
> Lets move the HVM part before the gnttab_map and remove the
> first call to gnttab_map.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Again, feel free to apply early.

David
