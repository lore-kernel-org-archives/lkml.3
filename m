Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3LDNGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:06:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:20546 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3LDNGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:06:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,824,1378857600"; 
   d="scan'208";a="78127531"
Message-ID: <1386162396.17466.77.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] xen/pvhvm: If xen_platform_pci=0 is set don't blow up.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <stefano.stabellini@eu.citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <boris.ostrovsky@oracle.com>,
        <leosilva@linux.vnet.ibm.com>, <ashley@ashleylai.com>,
        <peterhuewe@gmx.de>, <mail@srajiv.net>, <tpmdd@selhorst.net>,
        <tpmdd@sirrix.com>, <dmitry.torokhov@gmail.com>, <bhelgaas@google.com>,
        <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <tpmdd-devel@lists.sourceforge.net>, <linux-input@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Date: Wed, 4 Dec 2013 13:06:36 +0000
In-Reply-To: <529F2758.9070304@citrix.com>
References: <1386105246-14337-1-git-send-email-konrad.wilk@oracle.com>
	 <529F2758.9070304@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 13:00 +0000, David Vrabel wrote:
> On 03/12/13 21:14, Konrad Rzeszutek Wilk wrote:
> > 
> > Ian Campbell suggested getting rid of 'xen_platform_pci_unplug'
> > but unfortunatly the xen-blkfront driver is using it, so we
> > cannot do it.
> 
> I had a look at what blkfront was using this for and it seems dumb.  How
> did we end up with the frontend driver working around toolstack bugs?
> If HVM Linux guest didn't want (e.g.,) PV CDROM, the toolstack shouldn't
> have created one.

Note that this cdrom stuff is actually nothing to do with the unplug
variable -- it just happens to be right next to that check.

Not that the use of the unplug var there doesn't also look pretty odd...


