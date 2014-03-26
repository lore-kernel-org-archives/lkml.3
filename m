Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbaCZBHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 21:07:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54847 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbaCZBHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 21:07:09 -0400
Date: Tue, 25 Mar 2014 18:07:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
        Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
In-Reply-To: <1395514595.3667.10.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1403251806321.21733@chino.kir.corp.google.com>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be> <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org> <20140322170322.GA23583@thunk.org> <20140322101512.eaeb542b.akpm@linux-foundation.org> <20140322172606.GB23583@thunk.org>
 <20140322173207.GC23583@thunk.org> <20140322105524.7baec73a.akpm@linux-foundation.org> <1395514595.3667.10.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014, Joe Perches wrote:

> How about just changing this message to something like:
> 
> 			WARN("__GFP_NOFAIL",
> 			     "Use of __GFP_NOFAIL may cause the OOM handler to kill a random process\n" . $herecurr);

Because it doesn't, the GFP_NOFS allocation in question already cannot 
invoke the oom killer.
