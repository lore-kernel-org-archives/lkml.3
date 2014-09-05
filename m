Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbaIEJlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:41:36 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:57735 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557AbaIEJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:41:34 -0400
MIME-Version: 1.0
In-Reply-To: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
From: Jonas Gorski <jogo@openwrt.org>
Date: Fri, 5 Sep 2014 11:40:50 +0200
Message-ID: <CAOiHx=nGHGEHSLABnR9NL9ZEXYJN_TvJnyGud8mxseL2089fwg@mail.gmail.com>
Subject: Re: [RFC v2] device coredump: add new device coredump class
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 10:50 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>

Can't you just send from the correct address? ;p

(snip)

> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 4e7f0ff83ae7..134f763d90fd 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -165,6 +165,27 @@ config FW_LOADER_USER_HELPER_FALLBACK
>
>           If you are unsure about this, say N here.
>
> +config WANT_DEV_COREDUMP
> +       bool
> +       help
> +         Drivers should "select" this option if they desire to use the
> +         device coredump mechanism.
> +
> +config DISABLE_DEV_COREDUMP
> +       bool "Disable device coredump" if EXPERT
> +       help
> +         Disable the device coredump mechanism despite drivers wanting to
> +         use it; this allows for more sensitive systems or systems that
> +         don't want to ever access the information to not have the code,
> +         nor keep any data.
> +
> +         If unsure, say N.
> +
> +config DEV_COREDUMP
> +       bool
> +       default y if WANT_DEV_COREDUMP
> +       depends on !DISABLE_DEV_COREDUMP

How about the following to avoid negative options:

config DEV_COREDUMP
       bool "Enable device coredump" if EXPERT
       default y if WANT_DEV_COREDUMP
       help
         Enable the device coredump mechanism for drivers wanting to
         use it. Disabling allows for more sensitive systems or systems that
         don't want to ever access the information to not have the code,
         nor keep any data.

         If unsure, say Y.



Jonas
