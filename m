Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaIOO4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:56:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:48275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaIOO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:56:29 -0400
Date: Mon, 15 Sep 2014 15:56:25 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] rhashtable: Remove gfp_flags from insert and remove
 functions
Message-ID: <20140915145625.GE21541@casper.infradead.org>
References: <cover.1410782841.git.tgraf@suug.ch>
 <bd3aa4282e89b022620225101ab491e344852f5f.1410782841.git.tgraf@suug.ch>
 <1410784535.7106.164.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140915124937.GB21541@casper.infradead.org>
 <1410792596.7106.166.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410792596.7106.166.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/14 at 07:49am, Eric Dumazet wrote:
> On Mon, 2014-09-15 at 13:49 +0100, Thomas Graf wrote:
> 
> > Agreed. Will introduce this through a table parameter option when
> > converting the inet hash table.
> 
> I am not sure you covered the /proc/net/tcp problem yet ? (or inet_diag)

I haven't digged through inet_diag in all detail yet but was planning to
acquire ht->mutex to block expansions and then take bucket locks during
bucket traverals as done now. I will do that next but wanted to get this
out for comments in the meantime.
