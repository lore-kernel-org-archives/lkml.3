Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbaFQTjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:39:51 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:45129 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933509AbaFQTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:39:49 -0400
Date: Tue, 17 Jun 2014 14:39:46 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140617185510.GM4669@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406171437570.22064@gentwo.org>
References: <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <alpine.DEB.2.11.1406171053230.20610@gentwo.org> <20140617160040.GE31819@htj.dyndns.org>
 <20140617160508.GF31819@htj.dyndns.org> <alpine.DEB.2.11.1406171125340.20610@gentwo.org> <CA+55aFxHr8JXwDR-4g4z1mkXvZRtY=OosYcUMPZRD2upfooS1w@mail.gmail.com> <alpine.DEB.2.11.1406171345240.21931@gentwo.org> <20140617185510.GM4669@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Paul E. McKenney wrote:

> We are talking about one CPU initializing all CPUs' portions of
> dynamically allocated per-CPU memory, so there really is more than
> one CPU involved.

Well that only occurs on initialization before the address of the
struct that contains the offset is available to other processors.

During operation the percpu area functions like a single processor. And
its designed that way to avoid synchronization issues and take full
advantage of *no* synchronization for full speed. We compromise on that
for statistics but that is only read access.


