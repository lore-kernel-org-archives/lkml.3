Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbaJUT2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:28:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50582 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaJUT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:28:16 -0400
Message-ID: <5446B3CC.1080904@amacapital.net>
Date: Tue, 21 Oct 2014 12:28:12 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>, linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
References: <1413881397.30379.7.camel@hadess.net>
In-Reply-To: <1413881397.30379.7.camel@hadess.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 01:49 AM, Bastien Nocera wrote:
> Hey,
> 
> GNOME has had discussions with kernel developers in the past, and,
> fortunately, in some cases we were able to make headway.
> 
> There are however a number of items that we still don't have solutions
> for, items that kernel developers might not realise we'd like to rely
> on, or don't know that we'd make use of if merged.
> 
> I've posted this list at:
> https://wiki.gnome.org/BastienNocera/KernelWishlist
> 
> Let me know on-list or off-list if you have any comments about those, so
> I can update the list.

I don't know much about desktop environment infrastructure, but I think
the kernel probably already has a lot of what's needed for LinuxApps.

Tools like Sandstorm [1] (shameless plug, but it's a good example here)
can already sandbox normal-ish programs, and those sandboxes can be
launched without privilege [2].

Why is kdbus needed?  Why are overlays better than, say, btrfs
lightweight copies here?  Also, overlayfs might actually make it for 3.19.

[1] sandstorm.io
[2]
https://github.com/sandstorm-io/sandstorm/blob/master/src/sandstorm/supervisor-main.c%2B%2B

As for childfs, I implemented procfs polling a couple years ago, but it
never went anywhere:

http://lkml.kernel.org/g/1840e47fc4113af16989a4250d98bed62a9bce53.1354559528.git.luto@amacapital.net

If that would help, I can try to dust it off and get it in to the kernel.

--Andy
