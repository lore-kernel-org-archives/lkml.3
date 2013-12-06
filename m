Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3LFPef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:34:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3LFPed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:34:33 -0500
Date: Fri, 6 Dec 2013 10:34:13 -0500
From: Dave Jones <davej@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kent <kmo@daterainc.com>,
        Kristian Nielsen <knielsen@knielsen-hq.org>
Subject: Re: [PATCH] aio: clean up aio ring in the fail path
Message-ID: <20131206153413.GA31613@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-aio@kvack.org,
	fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Kent <kmo@daterainc.com>,
	Kristian Nielsen <knielsen@knielsen-hq.org>
References: <529F019A.2040401@cn.fujitsu.com>
 <20131206152654.GD13581@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206152654.GD13581@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 10:26:54AM -0500, Benjamin LaHaise wrote:
 > On Wed, Dec 04, 2013 at 06:19:06PM +0800, Gu Zheng wrote:
 > > Clean up the aio ring file in the fail path of aio_setup_ring
 > > and ioctx_alloc. And maybe it can fix the GPF issue reported by
 > > Dave Jones:
 > > https://lkml.org/lkml/2013/11/25/898
 > 
 > Good catch.  I've applied this to my aio-next tree.  It does indeed look 
 > like it could be the cause of Dave's GPF -- I'll try to trigger it with 
 > some other kernel debug options on and see if the EAGAIN failure case can 
 > trip it up.

I think I forgot to reply and let you know this seems to fix it for me.

	Dave

