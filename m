Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3LEAgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:36:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55533 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3LEAgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:36:16 -0500
Date: Thu, 5 Dec 2013 00:32:39 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>, Ian Rogers <irogers@google.com>,
        romlem@android.com
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat
 layer
Message-ID: <20131205003239.352c52c2@alan.etchedpixels.co.uk>
In-Reply-To: <CAMbhsRQHRK8xRzff_vCeqUwp=VGkByxVijxHpYjsKhA_oB7C=A@mail.gmail.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
	<20131204232118.1c3db844@alan.etchedpixels.co.uk>
	<CAMbhsRQHRK8xRzff_vCeqUwp=VGkByxVijxHpYjsKhA_oB7C=A@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> None of this (the patch series or the original code) is mine.  My

Sorry mistraced the attribution sequence

> question was more of a general one on designing ioctls, as well as
> concerns with changing the existing 32-bit api.

I think in general my advice would be:

If its already been screwed up
- sort the structures out for the 64bit version
- make the 32bit version and compat ones clean copies of what they are now
- don't try and pull stunts with alignof and other such tricks because
	- some poor bugger will have to debug it one day (and it might be
		  you some years after you forget how it worked)
	- most of our security holes show up in complex data parsing paths
- figure out whether its better to do compat fixups or just have 64bit use
  new structures and new ioctl numbers with the 32bit ones working but
  with 32bit offsets regardless of 32/64bit CPU mode.


and for new stuff
- design for 64bit safety in advance
- watch the padding rules and user alignment
- consider leaving some spare zero space on the end of the structs

Alan
