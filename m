Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaBMX6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:58:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBMX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:58:41 -0500
Date: Thu, 13 Feb 2014 15:59:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?5ZC056ug6YeR?= <falcon@meizu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] async: async device driver probing
Message-ID: <20140213235959.GA15564@kroah.com>
References: <uovsqced4yboii55ncyjppla.1391933910239@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <uovsqced4yboii55ncyjppla.1391933910239@email.android.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 08:40:43AM +0000, 吴章金 wrote:
> Hi, Greg
> 
> These two patches aim to thread the initcalls(only probes here) for SMP
> systems. to simplify the upgrade of Linux for Android smartphones, the modules
> are built into the Linux kernel image, and hence the initcalls are called in
> serial order, to speedup the booting, benefit from SMP, thread these initcalls
> may parallel the probings.
> 
> and I rechecked the deferred probing, seems it solves the problem of getting
> devices initialized in the right order, the probing will be threaded only if
> the probe fails with the -EPROBE_DEFER. it doesn't provide any mechanism to
> thread a probe explicitly.

It's up to the bus to do threaded probing, but watch out, that is almost
never the bottleneck in your boot process (hint, in Android, booting the
kernel is almost not even in the range that can be measured overall).
There are so many other things that Android does at boot time that could
be worked on instead of worrying about this :)

good luck,

greg k-h
