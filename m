Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaFJUJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:09:06 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:38939
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196AbaFJTwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:18 -0400
Date: Tue, 10 Jun 2014 14:52:15 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Joe Lawrence <joe.lawrence@stratus.com>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: docker crashes rcuos in __blkg_release_rcu
In-Reply-To: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
Message-ID: <alpine.DEB.2.10.1406101449150.18982@gentwo.org>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2014, Joe Lawrence wrote:

>
> .tickets is offset 0 from arch_spinlock_t, so RDI should be the
> arch_spinlock_t lock:
> RDI: 6b6b6b6b6b6b6b6b

Slub has overwritten the object when it was freed with 0x6b.
So this is an access after free.

It works without debug because the object may still linger around (but
there is no guarantee that the memory has not been reused).

