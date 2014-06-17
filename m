Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaFQSrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:47:07 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:58508
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932657AbaFQSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:47:05 -0400
Date: Tue, 17 Jun 2014 13:47:01 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <CA+55aFxHr8JXwDR-4g4z1mkXvZRtY=OosYcUMPZRD2upfooS1w@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1406171345240.21931@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <alpine.DEB.2.11.1406171053230.20610@gentwo.org>
 <20140617160040.GE31819@htj.dyndns.org> <20140617160508.GF31819@htj.dyndns.org> <alpine.DEB.2.11.1406171125340.20610@gentwo.org> <CA+55aFxHr8JXwDR-4g4z1mkXvZRtY=OosYcUMPZRD2upfooS1w@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Jun 2014, Linus Torvalds wrote:

> On Jun 17, 2014 6:28 AM, "Christoph Lameter" <cl@gentwo.org> wrote:
> >
> > Even alpha maintains the illusion of changes becoming visible in the
> > proper order for the currently executing thread. No barriers are needed.
>
> No Christoph, alpha really doesn't. Barriers needed.

Everythig breaks if a single hardware execution thread can no longer
observe a consistent view of the world of the data it modifies.

We are not talking about synchronization here between multiple hardware
threads. This is simply code running on a single hardware thread and all
architectures maintain the uniprocessor illusion there.


