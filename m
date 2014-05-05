Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaEETcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:32:25 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36721 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaEETcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140505180530.GA18465@intel.com>
References: <20140505180530.GA18465@intel.com>
Date: Mon, 5 May 2014 12:32:22 -0700
X-Google-Sender-Auth: zkk7JoLmSVWGsnNw7Ob-gLAzhsk
Message-ID: <CAODwPW_57G+Lebe2Xarem9P-L6ePtAaZfy5kpNVEtgkWbc0FWw@mail.gmail.com>
Subject: Re: [regression 3.15-rc3] Resume from s4 broken by 1f81b6d22a5980955b01e08cf27fb745dc9b686f
From: Julius Werner <jwerner@chromium.org>
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... very odd. I unfortunately don't have a machine that can easily
do S4 at hand, but I did test this on an IVB with XHCI_RESET_ON_RESUME
in S3 (essentially the same code path), and I didn't run into any
problems.

How exactly does your machine fail on resume? Is it a kernel crash or
just a hang? Can you try getting some debug output (by setting 'echo N
> /sys/module/printk/parameters/console_suspend' and trying to catch
the crash on the screen or a serial line, or maybe through pstore)? I
really don't see much that could go wrong with this patch, so without
more info it will be hard to understand your problem.

Also, I noticed that you have two HID devices plugged in during
suspend. Does it make a difference if you have different devices (e.g.
a mass storage stick) or none at all?
