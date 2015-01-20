Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbbATSQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:16:21 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42738 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbATSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:16:17 -0500
MIME-Version: 1.0
In-Reply-To: <20150120180247.22722.92597@quantum>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
	<1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
	<20150120180247.22722.92597@quantum>
Date: Tue, 20 Jan 2015 13:16:16 -0500
Message-ID: <CAF6AEGsPGCAHxqqRR7wWGxbiuS1HwTxF8fMb=VaL8T_qj85=TQ@mail.gmail.com>
Subject: Re: [PATCH 01/36] clk: Introduce clk_try_parent()
From: Rob Clark <robdclark@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 1:02 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Thierry Reding (2015-01-20 02:48:20)
>> From: Thierry Reding <treding@nvidia.com>
>>
>> This new function is similar to clk_set_parent(), except that it doesn't
>> actually change the parent. It merely checks that the given parent clock
>> can be a parent for the given clock.
>>
>> A situation where this is useful is to check that a particular setup is
>> valid before switching to it. One specific use-case for this is atomic
>> modesetting in the DRM framework where setting a mode is divided into a
>> check phase where a given configuration is validated before applying
>> changes to the hardware.
>
> Can you describe why this was needed for your atomic modesetting work?
> What problem did you hit in the driver that required this new check?

In particular, for an async atomic update, we need to do everything
that may potentially fail up front before returning to userspace.
Additionally there is a 'testonly' flag so that userspace can ask if a
particular display configuration is possible.

BR,
-R

> Thanks,
> Mike
>
