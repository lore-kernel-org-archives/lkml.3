Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3IFP7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab3IFP7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:59:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com>
References: <CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com> <cover.1378418255.git.milosz@adfin.com> <alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, Sage Weil <sage@inktank.com>, sprabhu@redhat.com,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
From: David Howells <dhowells@redhat.com>
Date: Fri, 06 Sep 2013 16:59:02 +0100
Message-ID: <18764.1378483142@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> After running this for a day on some loaded machines I ran into what
> looks like an old issue with the new code. I remember you saw an issue
> that manifested it self in a similar way a while back.
> 
> [13837253.462779] FS-Cache: Assertion failed
> [13837253.462782] 3 == 5 is false
> [13837253.462807] ------------[ cut here ]------------
> [13837253.462811] kernel BUG at fs/fscache/operation.c:414!

Bah.

I forgot to call fscache_op_complete().  Patch updated and repushed.

Btw, I've reordered the patches to put the CIFS patch last.  Can you merge the
patches prior to the CIFS commit from my branch rather than cherry picking
them so that if they go via two different routes, GIT will handle the merge
correctly?  I've stuck a tag on it (fscache-fixes-for-ceph) to make that
easier for you.

I've also asked another RH engineer to try doing some basic testing on the
CIFS stuff - which may validate the fscache_readpages_cancel patch.

David
