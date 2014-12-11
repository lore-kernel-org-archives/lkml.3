Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221AbaLKRSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:18:34 -0500
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:34582 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932521AbaLKRSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:18:33 -0500
Date: Thu, 11 Dec 2014 11:18:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jesper Dangaard Brouer <brouer@redhat.com>
cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo.kim@lge.com
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
In-Reply-To: <20141211175058.64a1c2fc@redhat.com>
Message-ID: <alpine.DEB.2.11.1412111117510.31381@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141211143518.02c781ee@redhat.com> <alpine.DEB.2.11.1412110902450.28416@gentwo.org> <20141211175058.64a1c2fc@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Jesper Dangaard Brouer wrote:

> I was expecting to see at least (specifically) 4.291 ns improvement, as
> this is the measured[1] cost of preempt_{disable,enable] on my system.

Right. Those calls are taken out of the fastpaths by this patchset for
the CONFIG_PREEMPT case. So the numbers that you got do not make much
sense to me.
