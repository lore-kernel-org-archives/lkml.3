Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3IIKSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3IIKSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:18:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANP1eJFtF7sRJkqg0xGqNjEzbz29GWywB8DAjfGFzDhCPSfjcg@mail.gmail.com>
References: <CANP1eJFtF7sRJkqg0xGqNjEzbz29GWywB8DAjfGFzDhCPSfjcg@mail.gmail.com> <cover.1378418255.git.milosz@adfin.com> <alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net> <CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com> <18764.1378483142@warthog.procyon.org.uk> <CANP1eJFMdcsgSwVO9jhYQwn2C+19db1uy5=du7yYFbmiB6em0A@mail.gmail.com> <alpine.DEB.2.00.1309061302300.12830@cobra.newdream.net>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, sprabhu@redhat.com,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
Date: Mon, 09 Sep 2013 11:17:58 +0100
Message-ID: <13594.1378721878@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> -               (1 << FSCACHE_OP_WAITING);
> +               (1 << FSCACHE_OP_WAITING) |
> +               (1 << FSCACHE_OP_UNUSE_COOKIE);

Yeah...  That'll do it.  We could just decrement n_active directly after
calling into the backend - after all, we cannot reduce n_active to 0 here
because the netfs cannot be calling fscache_relinquish_cookie() whilst also
calling this function - but this will do too.

David
