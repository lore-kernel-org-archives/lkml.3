Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3BZGg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:36:27 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58701 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3BZGg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:36:26 -0500
Message-ID: <1361860582.11403.2.camel@edumazet-glaptop>
Subject: Re: Regression found in loopback.c patch (0cf833a)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: salstrom@paintedocean.com
Cc: edumazet@google.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Mon, 25 Feb 2013 22:36:22 -0800
In-Reply-To: <512C567D.6010602@paintedocean.com>
References: <512C567D.6010602@paintedocean.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-25 at 22:30 -0800, Neil Salstrom wrote:
> Hello,
> 
> I believe I have found a regression in drivers/net/loopback.c which was
> introduced starting with the v3.7 kernel series (and also affects
> v3.8).  Oddly enough, it affects DVD playback (both physical disk and
> .iso files) in MythTV (I'm using v0.26 and compile from source).  I
> don't know if MythTV mounts a .iso or DVD over a loopback device but for
> whatever reason there is a problem.
> 
> When playing a DVD there is a constant stuttering of the video and
> corresponding audio dropouts.  This is continual with mythfrontend logs
> showing "Waiting for video buffers."
> 
> I found that any kernel before v3.7 did not cause this issue so I did a
> git bisect between v3.6 and v3.7.  The resulting bisection was to commit
> 0cf833a (net: loopback: set default mtu to 64K).
> 
> I downloaded the source to v3.7.9 and reverted the line:
> 
> dev->mtu = 64 * 1024;
> 
> back to:
> 
> dev->mtu = (16 * 1024) + 20 + 20 + 12;
> 
> 
> The resulting kernel did not cause the playback stuttering.  I have also
> compiled v3.8.0 using (16 * 1024) + 20 + 20 + 12; and again had no problems.
> 
> Please let me know if you have any questions.
> 
> Thank you,
> 
> Neil Salstrom
> 

Hmm, I suspect an application bug.

Try to find what particular mtu value makes the application going bad,
doing a dichotomy ?

No need to recompile the kernel :

ifconfig lo mtu XXXXX



