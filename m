Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaKXKBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:01:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61302 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaKXKBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:01:20 -0500
X-IronPort-AV: E=Sophos;i="5.07,448,1413244800"; 
   d="scan'208";a="195994710"
Date: Mon, 24 Nov 2014 10:00:53 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] xen-netback: do not report success if xenvif_alloc()
 fails
Message-ID: <20141124100053.GC30053@zion.uk.xensource.com>
References: <1416610588-19816-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1416610588-19816-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 01:56:28AM +0300, Alexey Khoroshilov wrote:
> If xenvif_alloc() failes, netback_probe() reports success as well as
> "online" uevent is emitted. It does not make any sense, but it just

Sorry, I don't follow. KOBJ_ONLINE event is not emitted in the event of
xenvif_alloc fails, is it?

> misleads users.
> 
> The patch implements propagation of error code if xenvif creation fails.
> 

This patch not only implements propagation of error code when xenvif
creation fails, but also when xenbus_scanf fails. You can simply write
"This patch implements propagation of error code for
backend_create_xenvif".

The rest of this patch looks good to me. Can you rewrite commit message
and resubmit, thanks.

Wei.
