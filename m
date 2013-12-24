Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3LXBPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:15:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3LXBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:15:11 -0500
MIME-Version: 1.0
In-Reply-To: <1385919125.7199.17.camel@x41.thuisdomein>
References: <1385919125.7199.17.camel@x41.thuisdomein>
Date: Tue, 24 Dec 2013 09:15:09 +0800
Message-ID: <CACVXFVM-KeJWXL9_H0Af=p+G=Dq5DhY9VEVuGnMiU_pZcS6BjA@mail.gmail.com>
Subject: Re: firmware: new "platform microcode" warning in v3.13-rc1+
From: Ming Lei <ming.lei@canonical.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 2, 2013 at 1:32 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> 0) Booting v3.13-rc1 and v3.13-rc2 triggers two new warnings on an
> (outdated, I'm afraid) ThinkPad X41:
>     [...]
>     <6>[   16.746119] libipw: 802.11 data/management/control stack, git-1.1.13
>     <6>[   16.746125] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
>     <4>[   16.761998] platform microcode: Direct firmware load failed with error -2
>     <4>[   16.762022] platform microcode: Falling back to user helper
>     <6>[   16.787885] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
>     <6>[   16.787895] ipw2200: Copyright(c) 2003-2006 Intel Corporation
>     <6>[   16.788741] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
>     [...]
>
> (I've added the surrounding lines because they suggest this is about the
> firmware for that wireless device. Please note that this device appears
> to work no worse than it did under v3.12.)
>
> 1) These warnings can be traced back to commit 3e358ac2bb5b ("firmware:
> Be a bit more verbose about direct firmware loading failure").

Yes, the warning was introduced in the commit since Neil thought it
is needed.

>
> 2) Is there something I'm supposed to do to silence these warnings? If
> so, what would that be? If not, can these messages perhaps be downgraded
> to dev_info or dev_notice?

Currently the messages are dumped via dev_warn(), and it is a bit difficult
to make policy about the warning: sounds like Neil need them, and you
don't like them, :-)


Thanks,
--
Ming Lei
