Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885Ab3IDSN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792Ab3IDSN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:13:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANP1eJEo_dNyYU+ZdvrwKfFPihig9m-Yf_-bUoXym-MF5bGnQg@mail.gmail.com>
References: <CANP1eJEo_dNyYU+ZdvrwKfFPihig9m-Yf_-bUoXym-MF5bGnQg@mail.gmail.com> <cover.1375999914.git.milosz@adfin.com> <306cbe63f85921ad40b00e3c7071be19cb6adf04.1375999914.git.milosz@adfin.com> <18832.1378311843@warthog.procyon.org.uk> <CANP1eJFKGD_h6rcWMWpxp3yOD+rz6p2P0B+2CTcy1taDwM9rdg@mail.gmail.com> <18284.1378315570@warthog.procyon.org.uk>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, Hongyi Jia <jiayisuse@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] new fscache interface to check cache consistency
Date: Wed, 04 Sep 2013 19:13:20 +0100
Message-ID: <16226.1378318400@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> Is it as simple as stick a mutex at the top of the
> __fscache_check_consistency function before we try to find the object?

You can lock a mutex in a function, but where are you actually going to place
the mutex struct?  And what other code is going to take it?  To do this, you'd
have to place the mutex struct in fscache_cookie.  The problem is that you
have to protect the pointer from fscache_cookie to fscache_object - so placing
the mutex in fscache_object doesn't help.

David
