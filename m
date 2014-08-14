Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaHNNfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:35:06 -0400
Received: from relay.parallels.com ([195.214.232.42]:39247 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbaHNNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:35:05 -0400
Date: Thu, 14 Aug 2014 17:34:50 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Manfred Spraul <manfred@colorfullife.com>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, Joe Perches <joe@perches.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] ipc: always handle a new value of auto_msgmni
Message-ID: <20140814133449.GB15307@paralelels.com>
References: <1407936117-2985-1-git-send-email-avagin@openvz.org>
 <53EC8369.8030406@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <53EC8369.8030406@colorfullife.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 11:37:45AM +0200, Manfred Spraul wrote:
> Hi Andrey,
> 
> On 08/13/2014 03:21 PM, Andrey Vagin wrote:
> >proc_dointvec_minmax() returns zero, if a new value has been set.
> >So we don't need to check all charectes have been handled.
> What do you use auto_msgmni for?

We disable it to check that criu restores a value of the msgmni sysctl correctly.

https://github.com/xemul/criu/blob/master/test/zdtm/live/static/ipc_namespace.c

> 
> I would propose to remove the whole logic - just always allow 32000 message
> queues.

I don't have objections.

> 
> --
>     Manfred
