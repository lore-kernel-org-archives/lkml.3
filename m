Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3EaIWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:22:18 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53496 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3EaIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <1368813243-29547-1-git-send-email-jon.mason@intel.com>
References: <1368813243-29547-1-git-send-email-jon.mason@intel.com>
Date: Fri, 31 May 2013 11:22:10 +0300
Message-ID: <CAHp75VfABzMAg7Ue+Mj_wsnXWsCzJrNH1HR-nbAQq5A2i9ncyw@mail.gmail.com>
Subject: Re: [PATCH] dmatest: add ability to disable pq and xor
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 8:54 PM, Jon Mason <jon.mason@intel.com> wrote:
> dmatest would create a thread to stress XOR and PQ, if the capability is
> present in the hardware.  Add the ability to disable XOR and PQ by
> disabling it if *_sources are set to zero.

Sorry, didn't comment this earlier.

Those threads are independent including MEMCPY stuff.
I think it's better to have one additional parameter let's say
type_of_test where you can set
1 for MEMCPY
2 for XOR
4 for PQ

Share this parameter via debugfs and use 0x07 as default value.
I doubt we need this as a module parameter.

--
With Best Regards,
Andy Shevchenko
