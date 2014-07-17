Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaGQFBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 01:01:02 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37390 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbaGQFBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 01:01:00 -0400
X-Sasl-enc: MrKXnKykg1wBg4kB48OsrC/5N7Whs2/6SoowY2dSwQop 1405573259
Message-ID: <1405573256.3002.25.camel@perseus.fritz.box>
Subject: Re: [PATCH 3/6] autofs4: allow RCU-walk to walk through autofs4.
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 13:00:56 +0800
In-Reply-To: <1405493777.2527.72.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <20140709234114.4525.46882.stgit@notabene.brown>
	 <1405485857.2527.38.camel@perseus.fritz.box>
	 <20140716155150.044c2ea3@notabene.brown>
	 <1405493777.2527.72.camel@perseus.fritz.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 14:56 +0800, Ian Kent wrote:
> > That looks a bit messy ... I wonder if we could have a new "ino" flag which
> > says "This dentry is mounted-on if it needs to be.  Gets set by ->lookup
> > and cleared by ->d_automount or when ->d_manage returns -EISDIR.
> 
> At one point DCACHE_NEED_AUTOMOUNT and DCACHE_MANAGE_TRANSIT were
> handled separately and DCACHE_NEED_AUTOMOUNT was cleared for rootless
> multi-mount dentrys following a mount and set again at expire. Not
> having to worry about managing that flag was also part of the
> optimization.
> 
> We could go back to managing DCACHE_NEED_AUTOMOUNT or add a new flag.
> I'm not fussy how it's done as long as it works. IIRC there was one
> quite convoluted if check (in the expire code) that was removed due to
> the optimization.

Umm ... using DCACHE_NEED_AUTOMOUNT rather than a new flag means using
an additional lock so perhaps a new flag would be preferred since
reducing lock overhead was the point of this.

Just a thought
Ian

