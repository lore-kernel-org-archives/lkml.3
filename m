Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3LDNAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:00:16 -0500
Received: from smtp.citrix.com ([66.165.176.89]:47592 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab3LDNAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:00:13 -0500
X-IronPort-AV: E=Sophos;i="4.93,824,1378857600"; 
   d="scan'208";a="80473227"
Message-ID: <529F2758.9070304@citrix.com>
Date: Wed, 4 Dec 2013 13:00:08 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <stefano.stabellini@eu.citrix.com>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <leosilva@linux.vnet.ibm.com>,
        <ashley@ashleylai.com>, <peterhuewe@gmx.de>, <mail@srajiv.net>,
        <tpmdd@selhorst.net>, <tpmdd@sirrix.com>, <dmitry.torokhov@gmail.com>,
        <bhelgaas@google.com>, <plagnioj@jcrosoft.com>,
        <tomi.valkeinen@ti.com>, <tpmdd-devel@lists.sourceforge.net>,
        <linux-input@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] xen/pvhvm: If xen_platform_pci=0 is set don't blow up.
References: <1386105246-14337-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386105246-14337-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 21:14, Konrad Rzeszutek Wilk wrote:
> 
> Ian Campbell suggested getting rid of 'xen_platform_pci_unplug'
> but unfortunatly the xen-blkfront driver is using it, so we
> cannot do it.

I had a look at what blkfront was using this for and it seems dumb.  How
did we end up with the frontend driver working around toolstack bugs?
If HVM Linux guest didn't want (e.g.,) PV CDROM, the toolstack shouldn't
have created one.

And perhaps more importantly, if you actually want a PV CDROM in a HVM
guest, it's not possible.

David
