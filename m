Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3AUKaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:30:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3AUKaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:30:20 -0500
Message-ID: <1358764210.4994.133.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 21 Jan 2013 11:30:10 +0100
In-Reply-To: <1358761496.4994.118.camel@marge.simpson.net>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:JgSlJrgOWGY2s4y7zgkKfLUvuHUK+eqcLVKRgJ4mUEB
 Fjm69CAPB1nSA5OlH1nKMTkym7v72BQWfhrZDI6P4lJIDLrEQ1
 1GNuIm5ndLqn2LBdvHYe4pk/fos4vVPVZsrTfSJBrS4QyUCS/K
 7vTobqU8ujme9iTtEz4owa/tKkeJiAdxlLXGNZEf2bb/u3Ts5a
 HM91TpaHJVwOIIIzytHMde/pKoLdsf6oXZIE2GESsKOZoZOAg8
 b16K2YXn9C4iyEzNU794HXD7wxbltfFHqWOXiHSTdyRKI8EVPk
 wqCDbIT94NFqGYyG/WZeAdCmPnkkqTyseG1ThNMVeLg2WdDX/f
 pjKvpt0rSf8PRg87+xfjTFjLevm/Z7kVQGBfiBuZsqS58bDbQ+
 JvYSH49+25o9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 10:44 +0100, Mike Galbraith wrote: 
> On Mon, 2013-01-21 at 17:22 +0800, Michael Wang wrote: 
> > On 01/21/2013 05:09 PM, Mike Galbraith wrote:
> > > On Mon, 2013-01-21 at 15:45 +0800, Michael Wang wrote: 
> > >> On 01/21/2013 03:09 PM, Mike Galbraith wrote:
> > >>> On Mon, 2013-01-21 at 07:42 +0100, Mike Galbraith wrote: 
> > >>>> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
> > >>>
> > >>>>> May be we could try change this back to the old way later, after the aim
> > >>>>> 7 test on my server.
> > >>>>
> > >>>> Yeah, something funny is going on.
> > >>>
> > >>> Never entering balance path kills the collapse.  Asking wake_affine()
> > >>> wrt the pull as before, but allowing us to continue should no idle cpu
> > >>> be found, still collapsed.  So the source of funny behavior is indeed in
> > >>> balance_path.
> > >>
> > >> Below patch based on the patch set could help to avoid enter balance path
> > >> if affine_sd could be found, just like the old logical, would you like to
> > >> take a try and see whether it could help fix the collapse?
> > > 
> > > No, it does not.
> > 
> > Hmm...what have changed now compared to the old logical?
> 
> What I did earlier to confirm the collapse originates in balance_path is
> below.  I just retested to confirm.

...

And you can add..

if (per_cpu(sd_llc_id, cpu) == per_cpu(sd_llc_id, prev_cpu))
goto unlock;

..before calling select_idle_sibling() the second time to optimize
department of redundancy department idle search algorithm ;-)

-Mike

