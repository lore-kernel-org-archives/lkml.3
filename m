Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab3LESto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:49:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab3LEStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:49:42 -0500
Date: Thu, 5 Dec 2013 10:49:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>,
        "romlem@android.com" <romlem@android.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
Message-ID: <20131205184940.GA10660@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
 <20131204183554.GA16693@kroah.com>
 <CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
 <20131204214325.GA19565@kroah.com>
 <CAMbhsRSkYuNBOt57PothjUO_6=vyJQAYsLmasq4Y-QVCT7fqZA@mail.gmail.com>
 <20131204220247.GA22031@kroah.com>
 <CAMP5Xgd-n4dgPsGN9KnD1c6WQ-CTAU1-3Z3mWgg=vqZQeru+UA@mail.gmail.com>
 <52A0C67D.90809@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A0C67D.90809@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 06:31:25PM +0000, Serban Constantinescu wrote:
> Hi all,
> 
> Thanks for your feedback! Sadly enough, being in a different
> time-zone, is not useful.
> 
> Sorry for the confusion related to why is this patch needed or not. I
> should highlight a bit more what is the patch enabling and what
> would be the different alternatives, at least from my perspective.
> 
> *64bit kernel/ 32bit userspace*
> 
> This patch series adds support for 32bit userspace running on 64bit
> kernels. Thus by applying this patch to your kernel you will be able
> to use any existing 32bit Android userspace on your 64bit platform,
> running a 64bit kernel. That is pure 32bit userspace with no 64bit
> support!
> 
> This means *no modifications to the 32bit userspace*. Therefore any
> applications or userspace side drivers, that uses the binder
> interface at a native level will not have to be modified. These kind
> of applications are not "good citizens" - the native binder API is
> not exposed in the Android NDK. However I do not know how many
> applications do this and if breaking the compatibility is a concernt
> for 32bit userspace running on 64bit kernels.

Um, I thought we were assured that the _only_ user of the kernel binder
interface was libbinder.  If other programs are touching this interface
"directly", you have bigger problems then just a 32/64 bit issue, and
that needs to be fixed.

In other words, you should be totally safe in modifying libbinder as
well as the kernel interface at the same time.

Now if you really want to do that or not is another issue, but it should
be possible (and in my opinion, the better option...)

thanks,

greg k-h
