Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab3K1NIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:08:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3K1NIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:08:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131126104034.GA4854@quack.suse.cz>
References: <20131126104034.GA4854@quack.suse.cz> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, smfrench@gmail.com,
        jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Thu, 28 Nov 2013 13:07:24 +0000
Message-ID: <14955.1385644044@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> wrote:

> > 		unsigned long long	st_blocks;
>   When we are doing this, can we please also change 'st_blocks' to
> 'st_bytes'? We track space usage in kernel in bytes for a long time so it
> would be nice to propagate it to userspace via stat instead of a special
> ioctl (at least quotacheck(8) needs to know the exact value).

Ummm...  I'm not sure about that.  Ideally, every field that is provided in
the current stat() buffer must still be there.  On the other hand, since
they're going to be moved around, presumably there will be a userspace
translation layer.

David
