Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3A1Uqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:46:47 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35658 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3A1Uqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:46:44 -0500
Date: Mon, 28 Jan 2013 12:46:39 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com
Subject: [regression] external HDD in USB3 enclosure cannot be dynamically
 removed (Re: Linux 3.7.5)
Message-ID: <20130128204639.GB7759@google.com>
References: <20130128045658.GA3488@kroah.com>
 <pan.2013.01.28.11.42.16.556318@googlemail.com>
 <20130128143907.GA2940@kroah.com>
 <pan.2013.01.28.20.33.44.918987@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2013.01.28.20.33.44.918987@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Holger,

Holger Hoffstaette wrote:
>> On Mon, Jan 28, 2013 at 12:42:16PM +0100, Holger Hoffstaette wrote:

>>> Apologies for being late but I'm afraid I just found at least one
>>> regression in this release.
>>>
>>> I have an external HDD in an USB3 enclosure for the occasional backup. I
>>> turn it on, it gets registered as sdX, I mount it/use it/unmount it and
>>> turn it off, which worked fine with kernels including 3.7.4. With 3.7.5
>
> FWIW it didn't really work with 3.7.4 either - just didn't notice before.
>
>>> the kernel seems no longer notified of the changed device power status;
>>> nothing in dmesg and the device stays in the list of SCSI devices as
>>> e.g. shown by lsscsi. This is repeatable. Turning the device back
>>> on/using it works fine, it's just that I cannot dynamically remove it
>>> any longer.
[...]
> No, current 3.8-rc5 did not work either. I first found 3.7.2 OK and 3.7.3
> bad. Bisecting found:
>
> --snip--
> f7965c0846d74b270e246c1470ca955d5078eb07 is the first bad commit
> commit f7965c0846d74b270e246c1470ca955d5078eb07
> Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Date:   Wed Nov 14 17:58:04 2012 -0800
>
>     USB: Handle warm reset failure on empty port.
>
>     commit 65bdac5effd15d6af619b3b7218627ef4d84ed6a upstream.
[...]
> Reverting this from 3.7.3 all the way to 3.8-rc5 makes USB 3.0
> disconnection/power-off device removal work again. Verified both on the
> bisection box and by now also the original machine.

Thanks for tracking this down.  Forwarding to relevant people.

Hope that helps,
Jonathan
