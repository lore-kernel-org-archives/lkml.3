Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3LEETz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:19:55 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61301 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3LEETx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:19:53 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1312041014460.1329-100000@iolanthe.rowland.org>
References: <1386116201-22131-1-git-send-email-jwerner@chromium.org>
	<Pine.LNX.4.44L0.1312041014460.1329-100000@iolanthe.rowland.org>
Date: Wed, 4 Dec 2013 20:19:52 -0800
X-Google-Sender-Auth: 75f0rdGl7AQKC6Qsm60Q7bC3814
Message-ID: <CAODwPW8aLDUyQbX1h2FkeFvWHCTV=sCFVztPP6kHpaaF-OBOOA@mail.gmail.com>
Subject: Re: [PATCH] usb: core: Abort deauthorization if unsetting
 configuration fails
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead, how about changing usb_set_configuration() so that it will
> never fail when the new config is -1?  Except perhaps for -ENODEV
> errors (the device has been disconnected), which
> usb_deauthorize_device() could check for.

Yes, that should work as well. It's really just one autoresume and one
disable_lpm that can fail in that case so it shouldn't be too
intrusive. I would prefer not to special-case ENODEV though, no need
to add more complexity than necessary.

I will write up a new version for that tomorrow.
