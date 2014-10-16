Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaJPUhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:37:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46815 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaJPUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:37:23 -0400
Date: Thu, 16 Oct 2014 13:37:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: hansechang@gmail.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Chang Huaixin <huaixin.chx@alibaba-inc.com>,
        jinsong.liu@alibaba-inc.com, Ian.Campbell@eu.citrix.com,
        dgdegra@tycho.nsa.gov, boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH] Input: xen-kbdfront - free grant table entry
 in xenkbd_disconnect_backend
Message-ID: <20141016203719.GB38361@dtor-ws>
References: <1413423992-3005-1-git-send-email-hansechang@gmail.com>
 <543FEBC5.2050202@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543FEBC5.2050202@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 05:01:09PM +0100, David Vrabel wrote:
> On 16/10/14 02:46, hansechang@gmail.com wrote:
> > From: Chang Huaixin <huaixin.chx@alibaba-inc.com>
> > 
> > xenkbd_disconnect_backend doesn't free grant table entry.
> > This bug affects live migration.
> > 
> > xenkbd_disconnect_backend uses gnttab_end_foreign_access_ref
> > to handle grant table entry which doesn't really free an entry.
> > 
> > Thus every time we do xenkbd_resume, grant table entry increses
> > by one. As an grant table entry occupies 8 bytes, an grant table
> > page has at most 512 entries. Every 512 times we do xenkdb_resume,
> > grant table pages increses by one.
> > 
> > After around 3500 times of live migration, grant table pages
> > will increase by 7, causing too many pages to populate and hitting
> > max_pages limit when assigning pages.Thus assign_pages will fail,
> > so will live migration.
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>
> 
> This need to be send to the input subsystem maintainers.

Applied, thank you.

-- 
Dmitry
