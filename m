Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaK1MJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:09:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:30647 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaK1MJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:09:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,476,1413270000"; 
   d="scan'208";a="629632159"
Date: Fri, 28 Nov 2014 14:09:29 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Loic Poulain <loic.poulain@intel.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>, Jiri Slaby <jslaby@suse.cz>,
        Chris Zhong <zyw@rock-chips.com>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>,
        mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
        wens@csie.org, alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: Handle no_console_suspend when uart
 loses state
Message-ID: <20141128120929.GC28114@kuha.fi.intel.com>
References: <1416011556-23422-1-git-send-email-dianders@chromium.org>
 <5469B828.90401@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5469B828.90401@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 09:56:08AM +0100, Loic Poulain wrote:
> >In certain suspend modes on certain boards the 8250 UART may lose
> >state when the device goes to suspend.  If we're using
> >no_console_suspend this can cause lots of problems during resume.
> >
> >Let's cache the basic UART config registers at suspend time and if we
> >notice that the UART loses state (by looking at a canary stored in the
> >scratch register) we'll restore it.
> 
> If I'm not wrong, it's already done in acpi_lpss suspend/resume (for
> 8250_dw).
> Commit c78b0830667a7e7c1f0ca65b76b33166a84806b3.

FYI, we are not saving any UART specific registers in acpi_lpss.c nor
any other bus controller's registers that are part of the LPSS block.
We are saving/restoring only the context of lpss specific register
there.

Cheers,

-- 
heikki
