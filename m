Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3AJXB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:01:26 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49758 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3AJXBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:01:23 -0500
Date: Thu, 10 Jan 2013 15:01:21 -0800
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Newton <will.newton@imgtec.com>, Chris Ball <cjb@laptop.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [REPOST PATCH v3 1/4] mmc: dw_mmc: Add "disable-wp" device tree
 property
Message-ID: <20130110230121.GA20584@quad.lixom.net>
References: <1354251857-21587-1-git-send-email-dianders@chromium.org>
 <1357842269-15062-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357842269-15062-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 10:24:26AM -0800, Doug Anderson wrote:
> The "disable-wp" property is used to specify that a given SD card slot
> doesn't have a concept of write protect.  This eliminates the need for
> special case code for SD slots that should never be write protected
> (like a micro SD slot or a dev board).
> 
> The dw_mmc driver is special in needing to specify "disable-wp"
> because the lack of a "wp-gpios" property means to use the special
> purpose write protect line.  On some other mmc devices the lack of
> "wp-gpios" means that write protect should be disabled.

Hi,

The previous code used the controller-common quirk field to set a
per-controller DW_MCI_QUIRK_NO_WRITE_PROTECT. Is there really need to
do this per-slot? And if so, please explain in the commit message why
there is need for a brand new quirk for the same functionality.

It's even uncertain if there are any systems out there that uses the
multi-slot functionality of this driver to date, most seem to map one
slot per controller in the first place...


-Olof
