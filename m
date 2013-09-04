Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763311Ab3IDR0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:26:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab3IDR0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:26:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANP1eJFKGD_h6rcWMWpxp3yOD+rz6p2P0B+2CTcy1taDwM9rdg@mail.gmail.com>
References: <CANP1eJFKGD_h6rcWMWpxp3yOD+rz6p2P0B+2CTcy1taDwM9rdg@mail.gmail.com> <cover.1375999914.git.milosz@adfin.com> <306cbe63f85921ad40b00e3c7071be19cb6adf04.1375999914.git.milosz@adfin.com> <18832.1378311843@warthog.procyon.org.uk>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, Hongyi Jia <jiayisuse@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] new fscache interface to check cache consistency
Date: Wed, 04 Sep 2013 18:26:10 +0100
Message-ID: <18284.1378315570@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> If the cache is withdrawn and we're starting anew I would consider
> that to okay. I would consider an empty page cache for a cookie to be
> consistent since there's nothing stale that I can read. Unless there's
> another synchronization issue that I'm missing in fscache.

The problem is that the fscache_object struct may be deallocated whilst you're
using it.

David
