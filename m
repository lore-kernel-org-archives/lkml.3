Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3FXNIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:08:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60001 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3FXNI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:08:26 -0400
Message-ID: <1372079315.32157.15.camel@linux>
Subject: Re: Per route MTU settings are broken in linux kernel 3.2
From: Yura Pakhuchiy <pakhuchiy@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        stable@vger.kernel.org
Date: Mon, 24 Jun 2013 20:08:35 +0700
In-Reply-To: <1372077951.21189.16.camel@deadeye.wl.decadent.org.uk>
References: <1372063443.32157.10.camel@linux>
	 <1372077951.21189.16.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 13:45 +0100, Ben Hutchings wrote:
> On Mon, 2013-06-24 at 15:44 +0700, Yura Pakhuchiy wrote:
> > Hello Ben,
> > 
> > Looks like setting per route MTU (as described in [1]) is broken in
> > Linux kernel 3.2. I tested with newer Ubuntu kernels 3.5 and 3.8 and it
> > looks like problem is fixed there. I filled Ubuntu bug report [2] with
> > more details and sample script which illustrates problem. But since this
> > problem is probably also present in stock kernel (not just in Ubuntu),
> > is it possible to backport fixes to stable 3.2 series?
> > 
> > 1. http://lartc.org/howto/lartc.cookbook.mtu-discovery.html
> > 2. https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1177507
> 
> Sure, what are the fixes?

Actually, I do not know :-( Ubuntu devs have not fixed this problem in
Ubuntu 3.2 kernel. But these commits in mainline kernel looks related:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=9b04f350057863d1fad1ba071e09362a1da3503e
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=5f2d04f1f9b52604fca6ee08a77972c0df67e082
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=d851c12b60471188e15e5c8405b289073e8dd025
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=7f92d334ba19a0d8e96f8f8f092219553367d921
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=ee9a8f7ab2edf801b8b514c310455c94acc232f6
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=38d523e2948162776903349c89d65f7b9370dadb
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=fa1e492aa3cbafba9f8fc6d05e5b08a3091daf4a
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=05ab86c55683410593720003442dde629782aaac
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=9cb3a50c5f63ed745702972f66eaee8767659acd
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=b44108dbdbaa07c609bb5755e8dd6c2035236251

However I'm not sure whether they all are required or sufficient to fix
everything correctly.


-- 
Best regards,
        Yura

