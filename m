Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094AbaDPAK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:10:26 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55798 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDPAKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:10:25 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 16 Apr 2014 09:10:49 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: ak@linux.intel.com, penberg@iki.fi, linux-kernel@vger.kernel.org
Subject: Re: [3.15-rc1 slab] Oops when reading /proc/slab_allocators
Message-ID: <20140416001049.GC14564@js1304-P5Q-DELUXE>
References: <201404092036.CEF21247.VFSQFFMLOJOOtH@I-love.SAKURA.ne.jp>
 <20140410073918.GB8204@js1304-P5Q-DELUXE>
 <201404102054.BJI60908.OOFVLQFOSFHMJt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404102054.BJI60908.OOFVLQFOSFHMJt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:54:37PM +0900, Tetsuo Handa wrote:
> Joonsoo Kim wrote:
> > There was another report about this problem and I have already fixed
> > it, although it wasn't reviewed and merged. See following link.
> > 
> > https://lkml.org/lkml/2014/3/11/119
> 
> OK. That patch fixes this problem.
> 
> Commit b1cb0982 changed the way of walking objects, didn't it? Then,
> it could happen that slab leak detector code walking all objects
> triggers an oops.

Yeah, although it doesn't walks all objects, it walks non-active
objects and it is problematic. This behaviour comes from my patches :)

> 
> > In that time, I thought that this problem wasn't related to my patches,
> > but your bisect report say that it is from my patches. I will dig into
> > the problem more deeply as soon as possible and make proper fix.
> 
> I see. Here is a minimal kernel config and test script for qemu on CentOS 6.5.
> http://I-love.SAKURA.ne.jp/tmp/config-pre-3.15-rc1-min

Thanks.
I already sent another patch to fix this bug and cc'ed you.

Thanks.
