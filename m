Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3CKRwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:52:18 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:21885 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3CKRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:52:16 -0400
Message-ID: <1363024331.2608.9.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 3/6] i2c: Ignore return value of i2c_del_adapter()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Shawn Guo <shawn.guo@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Lars Poeschel <poeschel@lemonage.de>
Date: Mon, 11 Mar 2013 17:52:11 +0000
In-Reply-To: <1362853009-20789-4-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
	 <1362853009-20789-4-git-send-email-lars@metafoo.de>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19708.004
X-TM-AS-Result: No--15.532800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-09 at 19:16 +0100, Lars-Peter Clausen wrote:
> i2c_del_adapter() always returns 0. So all checks testing whether it will be
> non zero will always evaluate to false and the conditional code is dead code.
> This patch updates all callers of i2c_del_mux_adapter() to ignore the return
> value and assume that it will always succeed (which it will). In a subsequent
> patch the return type of i2c_del_adapter() will be made void.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Ben Hutchings <bhutchings@solarflare.com>

Acked-by: Ben Hutchings <bhutchings@solarflare.com>
(for the sfc changes)

> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Marek Vasut <marex@denx.de> (commit_signer:11/20=55%)

You should probably remove that get_maintainer.pl annotation!

Ben.

> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Lars Poeschel <poeschel@lemonage.de>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
[...]

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

