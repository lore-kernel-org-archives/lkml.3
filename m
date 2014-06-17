Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaFQFLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:11:20 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:41019 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913AbaFQFLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:11:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8SAPrMn1NXQw3N/2dsb2JhbABagw2DR6daAQEBAQEBBQGZIgICAYEPF3WEAwEBBAEnExwjBQsIAxguOR4GE4g6DAHLGReFY4gvZAeEQwEDhGMCiweKVgGTWINCO4Ex
Date: Tue, 17 Jun 2014 07:11:29 +0200
From: Fabian Frederick <fabf@skynet.be>
To: David Rientjes <rientjes@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, sage <sage@inktank.com>
Subject: Re: [PATCH 1/1 RESEND] fs/ceph/export.c: add static to local
 function
Message-Id: <20140617071129.66a61dd61f354d75a7dfcab4@skynet.be>
In-Reply-To: <alpine.DEB.2.02.1406161701370.21018@chino.kir.corp.google.com>
References: <20140615083422.8d3b4ab0f2b1c70eeef9ae03@skynet.be>
	<alpine.DEB.2.02.1406161701370.21018@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 17:02:17 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Sun, 15 Jun 2014, Fabian Frederick wrote:
> 
> > ceph_get_parent is only used in fs/ceph/export.c
> > 
> > Cc: Sage Weil <sage@inktank.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  fs/ceph/export.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > index 00d6af6..8d7d782 100644
> > --- a/fs/ceph/export.c
> > +++ b/fs/ceph/export.c
> > @@ -169,7 +169,7 @@ static struct dentry *__get_parent(struct super_block *sb,
> >  	return dentry;
> >  }
> >  
> > -struct dentry *ceph_get_parent(struct dentry *child)
> > +static struct dentry *ceph_get_parent(struct dentry *child)
> >  {
> >  	/* don't re-export snaps */
> >  	if (ceph_snap(child->d_inode) != CEPH_NOSNAP)
> 
> Not sure what tree you're modifying, this is fixed by commit e84be11c5360 
> ("ceph: ceph_get_parent() can be static") in Linus's tree.
Strange, I sent first version some weeks ago and it wasn't there two days ago.
Maybe I missed a pull :)

Thanks,
Fabian 
