Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaJPQGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:06:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20164 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJPQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:05:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,733,1406592000"; 
   d="scan'208";a="183215858"
Message-ID: <543FEBC5.2050202@citrix.com>
Date: Thu, 16 Oct 2014 17:01:09 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <hansechang@gmail.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Chang Huaixin <huaixin.chx@alibaba-inc.com>, <jinsong.liu@alibaba-inc.com>,
        <Ian.Campbell@eu.citrix.com>, <david.vrabel@citrix.com>,
        <dgdegra@tycho.nsa.gov>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] Input: xen-kbdfront - free grant table entry
 in xenkbd_disconnect_backend
References: <1413423992-3005-1-git-send-email-hansechang@gmail.com>
In-Reply-To: <1413423992-3005-1-git-send-email-hansechang@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/14 02:46, hansechang@gmail.com wrote:
> From: Chang Huaixin <huaixin.chx@alibaba-inc.com>
> 
> xenkbd_disconnect_backend doesn't free grant table entry.
> This bug affects live migration.
> 
> xenkbd_disconnect_backend uses gnttab_end_foreign_access_ref
> to handle grant table entry which doesn't really free an entry.
> 
> Thus every time we do xenkbd_resume, grant table entry increses
> by one. As an grant table entry occupies 8 bytes, an grant table
> page has at most 512 entries. Every 512 times we do xenkdb_resume,
> grant table pages increses by one.
> 
> After around 3500 times of live migration, grant table pages
> will increase by 7, causing too many pages to populate and hitting
> max_pages limit when assigning pages.Thus assign_pages will fail,
> so will live migration.

Acked-by: David Vrabel <david.vrabel@citrix.com>

This need to be send to the input subsystem maintainers.

David
