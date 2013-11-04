Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3KDU2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:28:11 -0500
Received: from one.firstfloor.org ([193.170.194.197]:57137 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3KDU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:28:08 -0500
Date: Mon, 4 Nov 2013 21:28:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Solving M produces N consumers scalability problem
Message-ID: <20131104202806.GL29695@two.firstfloor.org>
References: <CAOMFOmWzERR7MDe65YHo--GdbO+QfnxZK=uWd7d3vCZ6ca97fw@mail.gmail.com>
 <87wqkovvzs.fsf@tassilo.jf.intel.com>
 <CAOMFOmVrBB5Pj9hXaooQF1XNkLqUW-LBux5jbsrYArnpQh5iCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmVrBB5Pj9hXaooQF1XNkLqUW-LBux5jbsrYArnpQh5iCg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This solution pretty-much equivalent to per-CPU data structures. And

No it's not, it doesn't require one queue per CPU.

A CPU these days isn't really a CPU anymore, but often a CPU thread,
which is much more light weight. So having a queue per CPU is often
total overkill, and amplifies any per queue costs (like invalidation)

-Andi
