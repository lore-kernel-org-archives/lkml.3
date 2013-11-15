Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3KOO20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:28:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab3KOO2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:28:20 -0500
Subject: Re: [Cluster-devel] [PATCH 0/6] list: introduce
 list_last_entry_or_null()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, jfs-discussion@lists.sourceforge.net,
        jiri@resnulli.us, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        oleg@redhat.com, akpm@linux-foundation.org
In-Reply-To: <20131115141100.GA17659@infradead.org>
References: <5285A33C.4040808@oracle.com>
	 <20131115141100.GA17659@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 15 Nov 2013 14:26:53 +0000
Message-ID: <1384525613.2747.60.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2013-11-15 at 06:11 -0800, Christoph Hellwig wrote:
> On Fri, Nov 15, 2013 at 12:29:48PM +0800, Jeff Liu wrote:
> > Hi Folks,
> > 
> > This patch is trying to introduce a new list helper to retrieve the
> > last entry or return NULL if the list is empty corresponding to it,
> > which is inspired by Jiri Pirko's list_first_entry_or_null().
> 
> How did we end up with the stupid _or_null prefix there?  I think the
> functionality is useful, but the naming is way to verbose, especially
> given that a list_first_entry or list_last_entry that optimizes away
> that one check doesn't seem useful.
> 
> Instead of encoding detailed semantics in the name a good kerneldoc
> comment is way better.
> 

Also, in two of the cases (patch 3 and patch 6) we don't want NULL in
the case that the list is empty, and instead want another pointer which,
after the patches, requires an extra "if". Now I suspect that the
optimizer will sort that out (I've not checked) so its probably not too
big an issue. However, if instead of returning NULL for list empty, we
had an extra argument to the function, then it could return whatever
pointer was required for each case, whether NULL or otherwise,

Steve.


