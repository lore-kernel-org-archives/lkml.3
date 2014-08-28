Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaH1SpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:45:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46785 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaH1SpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:45:16 -0400
Date: Thu, 28 Aug 2014 14:33:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 00/11] lib: introduce string_escape_mem and %*pE
 specifier
Message-ID: <20140828183330.GM13758@tuxdriver.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any objections?  Do you (Andy) want me to merge this through the
wireless tree?

John

On Wed, Aug 20, 2014 at 12:42:41PM +0300, Andy Shevchenko wrote:
> The introduced function is a kind of opposite to string_unescape. We have
> several users of such functionality each of them created custom implementation.
> The series contains clean up of test suite, adding new call, and switching few
> users to use it via %*pE specifier.
> 
> Test suite covers all of existing and most of potential use cases.
> 
> Changelog v3:
> - address Joe's comments (typos and styling of documentation / commit messages)
> - add patch 7/11
> - rebase on top of recent linux-next
> 
> Changelog v2:
> - addressed Joe's comments:
>  - added patch 4/10
>  - moving patches 5/10-10/10 to %*pE instead of direct string_escape_mem call,
>    as a result the series and code looks cleaner 
> - address few of Andrew's comments:
>  - added patch 1/10
>  - kernel documentation moved to c-file
>  - when test case fails the necessary messages are printed on KERN_WARNING
>    level
> 
> Andy Shevchenko (11):
>   lib / string_helpers: move documentation to c-file
>   lib / string_helpers: refactoring the test suite
>   lib / string_helpers: introduce string_escape_mem()
>   lib/vsprintf: add %*pE[achnops] format specifier
>   wireless: libertas: print esaped string via %*pE
>   wireless: ipw2x00: print SSID via %*pE
>   wireless: hostap: proc: print properly escaped SSID
>   lib80211: remove unused print_ssid()
>   staging: wlan-ng: use %*pEhp to print SN
>   staging: rtl8192e: use %*pEn to escape buffer
>   staging: rtl8192u: use %*pEn to escape buffer
> 
>  Documentation/printk-formats.txt               |  32 +++
>  drivers/net/wireless/hostap/hostap_proc.c      |   4 +-
>  drivers/net/wireless/ipw2x00/ipw2100.c         |  22 +-
>  drivers/net/wireless/ipw2x00/ipw2200.c         | 270 +++++++--------------
>  drivers/net/wireless/ipw2x00/libipw_rx.c       |  65 +++---
>  drivers/net/wireless/ipw2x00/libipw_wx.c       |  16 +-
>  drivers/net/wireless/libertas/cfg.c            |   8 +-
>  drivers/net/wireless/libertas/mesh.c           |   7 +-
>  drivers/staging/rtl8192e/rtllib.h              |  14 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211.h |  14 +-
>  drivers/staging/wlan-ng/prism2sta.c            |  28 +--
>  include/linux/string_helpers.h                 |  65 +++---
>  include/net/lib80211.h                         |   5 -
>  lib/string_helpers.c                           | 312 +++++++++++++++++++++++++
>  lib/test-string_helpers.c                      | 250 +++++++++++++++++++-
>  lib/vsprintf.c                                 |  72 ++++++
>  net/wireless/lib80211.c                        |  32 ---
>  17 files changed, 822 insertions(+), 394 deletions(-)
> 
> -- 
> 2.1.0
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
