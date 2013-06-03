Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3FCNMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:12:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52011 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3FCNMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <1370262344.29283.255.camel@smile>
References: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAKohpo=5+6X79tJaHd0BvKzECNqpiUcp9eybSSMDcJCkF8HVng@mail.gmail.com>
	<1370262344.29283.255.camel@smile>
Date: Mon, 3 Jun 2013 18:42:31 +0530
Message-ID: <CAKohpokWj4fNxc3AQPvKoogJRjGaMkeU6r7OvPCkE2Rrj+OcGw@mail.gmail.com>
Subject: Re: [RFC PATCH v0 0/2] dw_dmac: move to own folder and split
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2013 17:55, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> I still have doubts about few things.
>
> I did renaming twice, first time it's actually moving to folder and
> keeping the same file names, and second time when I split driver. Might
> be better to do this in first patch? My logic here is to distinguish
> just moving, that's why I kept names.

What you did is absolutely correct and renaming makes more
sense in 2/2.

> In patch 2/2 I collect platform related code. I see a lot of #ifdefs
> related to OF and ACPI. I would like to split it further and create
> files like of.c and acpi.c. What do you think?

Naahh.. OF by itself doesn't mean anything here on this driver. It
belongs to all the users that are using DT to enumerate it (Mostly
ARM). And they are going to use platform_driver interface. So,
code is well located currently too..

ACPI, I am not sure.. you need these routines in your pci stuff too?
Keep it this way:
- Keep all the common stuff across pci and platform in core.c
- everything else in pci and platform files.

> And I forgot to mention that patch series relies on the patch I sent
> before (clean up for devm_ioremap_resources) and Vinod didn't apply yet.

I understood it when I tried to apply it at my end :)
