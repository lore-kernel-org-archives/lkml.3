Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbaEIQBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:01:31 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:45240 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbaEIQB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:01:29 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, linux-security-module@vger.kernel.org,
        eparis@redhat.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1399647534.2232.8.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1399554584.git.d.kasatkin@samsung.com> <29977.1399605003@jrobl> <536C8E64.6000009@samsung.com> <11673.1399627021@jrobl> <1399647534.2232.8.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Sat, 10 May 2014 01:01:27 +0900
Message-ID: <18674.1399651287@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> Another approach was posted here
> http://marc.info/?l=linux-security-module&m=138919062430367&w=2 which
> also was not upstreamed.

It might be better a little than previous one which handles the flag
temporarily. But, in order to make the code cleaner particulary for
do_blockdev_direct_IO(), I'd suggest
- make two new static inline functions like
  r = ima_aware_file_inode_mutex_lock(file) and ..._unlock(r, file).
- these new functions are complied when CONFIG_IMA is enabled, otherwise
  they are plain mutex_lock/unlock().
- then do_blockdev_direct_IO() can call them blindly.
- of course, O_DIRECT_HAVELOCK should be complied only when CONFIG_IMA
  is enabled too.

I can guess that several people thinks that is still "ugly locking", but
the deadlock is much ugly in real world. And we need some workaround for
it.


J. R. Okajima
