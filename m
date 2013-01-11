Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3AKV5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:57:01 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49438 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab3AKV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:57:00 -0500
Date: Fri, 11 Jan 2013 13:56:59 -0800
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 0/4] arm: vt8500: Add support for Wondermedia
 WM8750/WM8850
Message-ID: <20130111215659.GA16521@quad.lixom.net>
References: <1357935162-7672-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357935162-7672-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 12, 2013 at 09:12:38AM +1300, Tony Prisk wrote:
> The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:
> 
>   Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)
> 
> are available in the git repository at:
> 
>   git://server.prisktech.co.nz/git/linuxwmt.git tags/armsoc-3.9
> 
> for you to fetch changes up to 82c8f175662873f7f7f4c78698888ee963d7d967:
> 
>   arm: vt8500: Remove remaining mach includes (2012-12-28 21:05:19 +1300)
> 
> ----------------------------------------------------------------
> arm: vt8500: Add support for WM8750/WM8850. Cleanup multiplatform changes
> 
> This patchset adds support for the WM8750 (ARMv6) and WM8850 (ARMv7), and
> cleans up changes for multiplatform configuration.
> 
> Single platform Kconfig options are removed, along with the remaining
> mach/includes.
> 
> The debug-macro.s is moved to arm/include/debug/ to allow DEBUG_LL on
> multi-platform.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> 
> ----------------------------------------------------------------
> Tony Prisk (4):
>       arm: vt8500: Add support for Wondermedia WM8750/WM8850
>       arm: vt8500: Remove single platform Kconfig options
>       arm: vt8500: Convert debug-macro.S to be multiplatform friendly
>       arm: vt8500: Remove remaining mach includes

The first patch adds some Kconfig entries, and the second one removes them.
Also, all but the first patch are really about multiplatform enablement.

I suggest that you split off the last three (and rebase them to be
independent), and apply them to a multiplatform branch for vt8500. Then the
last one is a soc branch that goes on top of the multiplatform branch (i.e. you
build it on top of multiplatform). That way we can pull in the multiplatform
changes together with those for other platforms, and then take the wm8{7,8}50
branch goes in with the other new-soc support from other platforms.

Does that make sense? I'll be happy to provide more explanation if it doesn't.

-Olof

