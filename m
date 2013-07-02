Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3GBRvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:51:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32801 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3GBRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:51:35 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=DHx38szrmA4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XmgD9TfWiMYA:10 a=VwQbUJbxAAAA:8 a=AW3oBweNy5cexTvsksYA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372787493.22688.50.camel@gandalf.local.home>
Subject: Re: 3.6 NULL kernel dereference in skb_gro_receive()
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Tue, 02 Jul 2013 13:51:33 -0400
In-Reply-To: <1372783137.4979.10.camel@edumazet-glaptop>
References: <1372782217.22688.48.camel@gandalf.local.home>
	 <1372783137.4979.10.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 09:38 -0700, Eric Dumazet wrote:

> Could you check if your kernel has commit 2e71a6f8084e ("net: gro:

Yeah, I saw this in the git logs, and no our tree doesn't have that
commit.

> selective flush of packets"), and the fix contained in commit
> c3c7c254b2e8cd99b0adf288c2a1bddacd7ba255
> ("net: gro: fix possible panic in skb_gro_receive() ")
> 
> Normally, first commit was in 3.7-rc1, but maybe it was backported into
> you 3.6.11 kernel ?
> 
> Do you have a git tree for your kernel ?

I'm not sure if the Red Hat kernel has a public git tree, but it's
almost identical to my 3.6-rt tree:

git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

branch: v3.6-rt

-- Steve


