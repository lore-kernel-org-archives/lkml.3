Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3LaKge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:36:34 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:60052 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3LaKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:36:32 -0500
MIME-Version: 1.0
In-Reply-To: <52C29918.4060102@blueyonder.co.uk>
References: <52C29918.4060102@blueyonder.co.uk>
Date: Tue, 31 Dec 2013 05:36:32 -0500
X-Google-Sender-Auth: tGZHGUTNPABcI2aO-8PczScpo4I
Message-ID: <CAKb7UvhBunpMC6mzjRg7Zb5gGPPYj99=2jd+Lgnr-qeXFs0w9A@mail.gmail.com>
Subject: Re: Possible 3.13-rc nouveau regression with GT 560 Ti
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: sboyce@blueyonder.co.uk
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 5:14 AM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> System x86_64 with openSUSE 13.1.
> X.Org version: 1.14.99.905
>
> openSUSE 12.2 kernels boot successfully into a graphical screen, login to
> KDE4, etc. all normal.
>
> 3.13-rc kernels boot fully with X running but no graphical screen and it
> freezes in VC with not all the startup messages displayed but I could ssh in
> from another box to check dmesg and logs.
>
> Xorg.0.log which I thought I had saved did not log an error.
>
> dmesg said "nouveau Playlist update failed".
>
> Changed the GeForce GT 560 Ti for a GeForce 8600 GT and 3.13.0-rc6 is up and
> running.
>
> If necessary I can go back to the GT 560 Ti to gather dmesg and Xorg log
> information.

Having a dmesg would be nice. One thing I can think of off-hand is
that 3.13-rc has MSI turned on by default. You can turn it off by
adding "nouveau.config=NvMSI=0" to your kernel cmdline. If that
doesn't help, a bisect restricted to drivers/gpu/drm/nouveau should
show the offending commit fairly quickly.

  -ilia
