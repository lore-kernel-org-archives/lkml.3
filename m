Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab3BSOs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:48:56 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:59401 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965Ab3BSOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:48:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,695,1355097600"; 
   d="scan'208";a="1612303"
Message-ID: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
Subject: [PATCH V2] xen: event channel arrays are xen_ulong_t and not
 unsigned long
From: Ian Campbell <Ian.Campbell@citrix.com>
To: xen-devel <xen-devel@lists.xen.org>
CC: <linux-arm-kernel@lists.infradead.org>, "Tim (Xen.org)" <tim@xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Keir (Xen.org)" <keir@xen.org>, Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 19 Feb 2013 14:48:47 +0000
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches (one for Xen, one for Linux) switch Xen event
channels from unsigned long to xen_ulong_t.

On arm, this enables us to have the same interface on arm32 and arm64
because xen_ulong_t is a 64-bit type on ARM.

On x86 there is no change because xen_ulong_t is unsigned long on x86.

Since this is an ABI change on ARM I hope we can get this in for the 3.9
merge window. I have deferred the other changes which I previously
posted along side this since they are not so critical.

Ian.

