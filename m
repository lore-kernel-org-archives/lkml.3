Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbaFYSYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:24:01 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49172 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbaFYSYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:24:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <44039675.8s16pHQIVH@wuerfel>
Cc: "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1403713591-17179-1-git-send-email-pdeschrijver@nvidia.com>
 <44039675.8s16pHQIVH@wuerfel>
Message-ID: <20140625182349.32686.25931@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: define and export __clk_get_debug for providers
Date: Wed, 25 Jun 2014 11:23:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (2014-06-25 11:07:37)
> On Wednesday 25 June 2014 19:26:31 Peter De Schrijver wrote:
> > Define and export a new function __clk_get_debug which returns the debugfs
> > directory entry pointer. This can be used by clock providers to add debugfs
> > entries which are not related to a specific clock type. Examples include the
> > ability to measure the rate of a clock. It can also be used by modules to
> > create new debugfs entries. This is useful if you want to expose features
> > for testing which can potentially cause system instability such as allowing
> > to change a clock's rate from userspace.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > 
> 
> Just an idea, but would it be better to add a pair of functions to add/remove
> debugfs files rather than exposing the dentry itself?

Arnd,

Yes, accessor functions are much better than exposing struct clk
internals.

Peter,

Just FYI, I'm trying to reverse the trend of prepending double
underscores for functions that are used by clock providers. That stuff
started out small and sort of grew out of control ;-)

Regards,
Mike

> 
>         Arnd
