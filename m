Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3F0Pet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:34:49 -0400
Received: from void.printf.net ([89.145.121.20]:42368 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3F0Per (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:34:47 -0400
From: Chris Ball <cjb@laptop.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olof@lixom.net>, Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mmc: dw_mmc: Handle late vmmc regulators with EPROBE_DEFER
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
	<1370626110-1731-1-git-send-email-dianders@chromium.org>
Date: Thu, 27 Jun 2013 11:34:39 -0400
In-Reply-To: <1370626110-1731-1-git-send-email-dianders@chromium.org> (Doug
	Anderson's message of "Fri, 7 Jun 2013 10:28:29 -0700")
Message-ID: <87vc4zo9dc.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Fri, Jun 07 2013, Doug Anderson wrote:
> It is possible to specify a regulator that should be turned on when
> dw_mmc is probed.  At the moment dw_mmc will fail to use the regulator
> properly if the regulator probes after dw_mmc.  Fix this problem by
> honoring EPROBE_DEFER.
>
> At the same time move the regulator code out of the slot init code.
> We only specify one regulator for the whole device and other parts of
> the code (like suspend/resume) assume that the regulator has only been
> enabled once.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Avoid hackery to detect regulators that will never show up.
> - Move regulator out of slot init--it doesn't belong there.

Thanks, pushed to mmc-next for 3.11.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
