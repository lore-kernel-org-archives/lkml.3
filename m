Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaEDRTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:19:50 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:12269 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaEDRTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 13:19:48 -0400
Message-ID: <1399223984.2570.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] IPC initialize shmmax and shmall from the current value
 not the default
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Marian Marinov <mm@1h.com>, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Date: Sun, 04 May 2014 10:19:44 -0700
In-Reply-To: <536621D4.60002@colorfullife.com>
References: <5365723D.7030303@1h.com>
	 <1399161216.2573.9.camel@buesod1.americas.hpqcorp.net>
	 <536621D4.60002@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-04 at 13:17 +0200, Manfred Spraul wrote:
> Hi Marian,
> 
> Note: The limits will soon be increased to (nearly) ULONG_MAX.
> I.e.: If you propose the patch because you are running into issues with 
> a too small SEMMAX after an unshare(CLONE_NEWIPC), then this will be 
> fixed soon.
> 
> 
> On 05/04/2014 01:53 AM, Davidlohr Bueso wrote:
> > On Sun, 2014-05-04 at 01:48 +0300, Marian Marinov wrote:
> >> When we are creating new IPC namespace that should be cloned from the current namespace it is a good idea to copy the
> >> values of the current shmmax and shmall to the new namespace.
> The idea sounds reasonable:
> If an admin has reduced the limits, then the reduction should also apply 
> after a unshare(CLONE_NEWIPC).
> 
> But:
> Your patch doesn't use the current shmmax, it uses the shmmax from 
> init_ipc_ns.
> Would it be possible to use the current values?
> 
> > Why is this a good idea?
> >
> > This would break userspace that relies on the current behavior.
> > Furthermore we've recently changed the default value of both these
> > limits to be as large as you can get, thus deprecating them. I don't
> > like the idea of this being replaced by namespaces.
> Davidlohr: We are not deprecating them, we make the default huge.
> The limits should stay as usable as they were.

Deprecating them in the sense that hopefully users will not set them
anymore. I'm not saying lets add the word "deprecated" it in the
manpage...

> 
> With regards to breaking user space, I must think about it a bit more.
> Right now, each new namespace starts with SEMMAX=32MB, i.e. an often 
> unusable default.
> 
> --
>      Manfred


