Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaA3WPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:15:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaA3WPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:15:40 -0500
Date: Thu, 30 Jan 2014 14:15:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mutex not unlocked on
 memcg_create_kmem_cache fail path
Message-Id: <20140130141538.a9e3977b5e7b76bdcf59a15f@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1401301411590.15271@chino.kir.corp.google.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com>
	<20140130130129.6f8bd7fd9da55d17a9338443@linux-foundation.org>
	<alpine.DEB.2.02.1401301310270.15271@chino.kir.corp.google.com>
	<20140130132939.96a25a37016a12f9a0093a90@linux-foundation.org>
	<alpine.DEB.2.02.1401301336530.15271@chino.kir.corp.google.com>
	<20140130135002.22ce1c12b7136f75e5985df6@linux-foundation.org>
	<alpine.DEB.2.02.1401301403090.15271@chino.kir.corp.google.com>
	<20140130140902.93d35d866f9ea1c697811f6e@linux-foundation.org>
	<alpine.DEB.2.02.1401301411590.15271@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 14:13:18 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> On Thu, 30 Jan 2014, Andrew Morton wrote:
> 
> > > Why?  We already construct the name in memcg_create_kmem_cache() 
> > > appropriately, we just want to avoid the kstrdup() in 
> > > kmem_cache_create_memcg() since it's pointless like my patch does.
> > 
> > oh, OK, missed that.
> > 
> > The problem now is that the string at kmem_cache.name is PATH_MAX
> > bytes, and PATH_MAX is huuuuuuuge.
> > 
> 
> It always was.

eh?  kmem_cache_create_memcg()'s kstrdup() will allocate the minimum
needed amount of memory.

