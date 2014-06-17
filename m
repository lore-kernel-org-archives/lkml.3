Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaFQAJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:09:32 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52729 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaFQAJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:09:29 -0400
Date: Mon, 16 Jun 2014 17:09:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Krause <xerofoify@gmail.com>
cc: Steve Wise <swise@opengridcomputing.com>, swise@chelsio.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
In-Reply-To: <CAPDOMVg8hT95Wcmy4VHdfsumEvc=w3dz8V8xP1QScsLK3buSxw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1406161707230.21018@chino.kir.corp.google.com>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com> <539F34E8.3000501@opengridcomputing.com> <alpine.DEB.2.02.1406161638360.21018@chino.kir.corp.google.com> <CAPDOMVg8hT95Wcmy4VHdfsumEvc=w3dz8V8xP1QScsLK3buSxw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Nick Krause wrote:

> If that is the case ,David I would mark bug id 44631 as closed due to no
> need for my if statement.

You don't want to depend on the implementation of the page allocator to 
never return NULL for orders < PAGE_ALLOC_COSTLY_ORDER with GFP_KERNEL, it 
could possibly change in the future and we wouldn't catch your dependency 
in send_flowc().  The size object size of the skbuff_head_cache slab cache 
could also change.  You don't need the suggested pr_warn(), though, since 
the page allocation failure warning would also be noisy enough.
