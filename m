Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab3HUVn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:43:57 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58412 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3HUVn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130821184042.GC3577@xanatos>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
	<20130821184042.GC3577@xanatos>
Date: Wed, 21 Aug 2013 14:43:55 -0700
X-Google-Sender-Auth: 92pqB1aC2KQB89WLuFnicaLn2ec
Message-ID: <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        mathias.nyman@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for the patch!  Did you test with a USB analyzer to see if the
> device was actually going into USB 2.0 Link PM?  I'd like to confirm we
> really aren't breaking anything for DW3 hosts by enabling this.

Yes, I did. The LPM transfers on the analyzer look good and the device
works as expected.

My platform only runs a 3.8 derivative, though, so I now have also
cherry-picked the BESL patches that went in since then to make sure
they don't break things. I had problems on one device until I found
the XHCI_BLC fix Mathias sent out this morning, so you should pick
that one up first. (Without it LPM doesn't break completely but seems
to assert resume for less time than the HIRD defines, so the device
sometimes gets confused and resets. I can't figure out how BESL is
really supposed to work since the XHCI spec from 8/14/12 where it's
supposedly defined doesn't seem to be publicly available.)
