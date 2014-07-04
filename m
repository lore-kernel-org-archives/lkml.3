Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbaGDVWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:22:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbaGDVWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:22:32 -0400
Date: Fri, 4 Jul 2014 23:22:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Olaf Hering <olaf@aepfle.de>
cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 13/72] floppy: bail out in open() if drive is not
 responding to block0 read
In-Reply-To: <20140703101233.GA28675@aepfle.de>
Message-ID: <alpine.LNX.2.00.1407042322030.1655@pobox.suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz> <e6732e00c9ffc318d21fca56e747f59f85d078a1.1397812482.git.jslaby@suse.cz> <20140703101233.GA28675@aepfle.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Olaf Hering wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> 
> > commit 7b7b68bba5ef23734c35ffb0d8d82079ed604d33 upstream.
> 
> > +static void floppy_rb0_cb(struct bio *bio, int err)
> >  {
> > -	complete((struct completion *)bio->bi_private);
> > +	struct rb0_cbdata *cbdata = (struct rb0_cbdata *)bio->bi_private;
> > +	int drive = cbdata->drive;
> > +
> > +	if (err) {
> > +		pr_info("floppy: error %d while reading block 0", err);
> 
> This change lacks a newline...

Fixed by 1c65df3d7 in Linus' tree.

-- 
Jiri Kosina
SUSE Labs
