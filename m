Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3HBKbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:31:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3HBKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:31:10 -0400
Date: Fri, 2 Aug 2013 03:31:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Cong Wang <amwang@redhat.com>
Cc: netdev@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Cluster-devel] [Patch net-next v2 6/8] fs: use generic union
 inet_addr and helper functions
Message-ID: <20130802103107.GA17244@infradead.org>
References: <1375427674-21735-1-git-send-email-amwang@redhat.com>
 <1375427674-21735-7-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375427674-21735-7-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 03:14:32PM +0800, Cong Wang wrote:
> From: Cong Wang <amwang@redhat.com>
> 
> nfs and cifs define some helper functions for sockaddr,
> they can use the generic functions for union inet_addr too.
> 
> Since some dlm code needs to compare ->sin_port, introduce a
> generic function inet_addr_equal_strict() for it.

Would sound more useful to have a sockaddr_equal case that can be used
on any sockaddr.  For cases that no current user handles just return
false.

