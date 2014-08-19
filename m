Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaHSGnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:43:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:59230 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaHSGnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:43:07 -0400
Date: Tue, 19 Aug 2014 10:42:55 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Manfred Spraul <manfred@colorfullife.com>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, Joe Perches <joe@perches.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] ipc: always handle a new value of auto_msgmni
Message-ID: <20140819064255.GA14360@paralelels.com>
References: <1407936117-2985-1-git-send-email-avagin@openvz.org>
 <53EC8369.8030406@colorfullife.com>
 <20140814133449.GB15307@paralelels.com>
 <53EFBF1C.5060407@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <53EFBF1C.5060407@colorfullife.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.24.25.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 10:29:16PM +0200, Manfred Spraul wrote:
> Hi Andrew,
> 
> On 08/14/2014 03:34 PM, Andrew Vagin wrote:
> >On Thu, Aug 14, 2014 at 11:37:45AM +0200, Manfred Spraul wrote:
> >>Hi Andrey,
> >>
> >>[...]
> >>What do you use auto_msgmni for?
> >We disable it to check that criu restores a value of the msgmni sysctl correctly.
> >
> >https://github.com/xemul/criu/blob/master/test/zdtm/live/static/ipc_namespace.c
> Thanks for the link, if I see it right, my patch would break your code:
> 
> http://marc.info/?l=linux-kernel&m=140782863804950
> 
> It removes auto_msgmni - and
> What do you think, should I leave auto_msgmni as a stale variable, perhaps
> with a pr_info() that it doesn't have any effect?

Yes, you should. For example "criu restore" will start failing, if you remove
auto_msgmni.
> 
> 
> --
>     Manfred
