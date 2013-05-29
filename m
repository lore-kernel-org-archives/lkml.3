Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966987Ab3E2Uso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:48:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966734Ab3E2Usi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:48:38 -0400
Date: Wed, 29 May 2013 13:48:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv12 2/4] zbud: add to mm/
Message-Id: <20130529134835.58dd89774f47205da4a06202@linux-foundation.org>
In-Reply-To: <20130529204236.GD428@cerebellum>
References: <1369067168-12291-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1369067168-12291-3-git-send-email-sjenning@linux.vnet.ibm.com>
	<20130528145911.bd484cbb0bb7a27c1623c520@linux-foundation.org>
	<20130529154500.GB428@cerebellum>
	<20130529113434.b2ced4cc1e66c7a0a520d908@linux-foundation.org>
	<20130529204236.GD428@cerebellum>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 15:42:36 -0500 Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> > > > I worry about any code which independently looks at the pageframe
> > > > tables and expects to find page struts there.  One example is probably
> > > > memory_failure() but there are probably others.
> > 
> > ^^ this, please.  It could be kinda fatal.
> 
> I'll look into this.
> 
> The expected behavior is that memory_failure() should handle zbud pages in the
> same way that it handles in-use slub/slab/slob pages and return -EBUSY.

memory_failure() is merely an example of a general problem: code which
reads from the memmap[] array and expects its elements to be of type
`struct page'.  Other examples might be memory hotplugging, memory leak
checkers etc.  I have vague memories of out-of-tree patches
(bigphysarea?) doing this as well.

It's a general problem to which we need a general solution.
