Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaIVWkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:40:06 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37126 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbaIVWkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:40:04 -0400
Date: Mon, 22 Sep 2014 19:39:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] media:st-rc: Misc fixes.
Message-ID: <20140922193956.6e445cd9@recife.lan>
In-Reply-To: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 22 Sep 2014 23:21:41 +0100
Srinivas Kandagatla <srinivas.kandagatla@linaro.org> escreveu:

> Hi Mauro,
> 
> Thankyou for the "[media] enable COMPILE_TEST for media drivers" patch
> which picked up few things in st-rc driver in linux-next testing.

Anytime. Yeah, the idea is to let more people to test and check for
hidden issues there.
> 
> Here is a few minor fixes to the driver, could you consider them for
> the next merge window.

Applied, thanks!

Btw, there are still lots of warnings there produced with smatch:

$ make ARCH=i386 C=1 CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CF=-D__CHECK_ENDIAN__ M=drivers/media
drivers/media/rc/st_rc.c:107:38: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:107:38:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:107:38:    got void *
drivers/media/rc/st_rc.c:110:53: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:110:53:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:110:53:    got void *
drivers/media/rc/st_rc.c:116:54: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:116:54:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:116:54:    got void *
drivers/media/rc/st_rc.c:120:45: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:120:45:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:120:45:    got void *
drivers/media/rc/st_rc.c:121:43: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:121:43:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:121:43:    got void *
drivers/media/rc/st_rc.c:150:46: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/st_rc.c:150:46:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:150:46:    got void *
drivers/media/rc/st_rc.c:153:42: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:153:42:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:153:42:    got void *
drivers/media/rc/st_rc.c:174:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:174:32:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:174:32:    got void *
drivers/media/rc/st_rc.c:177:48: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:177:48:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:177:48:    got void *
drivers/media/rc/st_rc.c:187:48: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:187:48:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:187:48:    got void *
drivers/media/rc/st_rc.c:204:42: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:204:42:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:204:42:    got void *
drivers/media/rc/st_rc.c:205:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:205:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:205:35:    got void *
drivers/media/rc/st_rc.c:215:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:215:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:215:35:    got void *
drivers/media/rc/st_rc.c:216:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:216:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:216:35:    got void *
drivers/media/rc/st_rc.c:269:22: warning: incorrect type in assignment (different address spaces)
drivers/media/rc/st_rc.c:269:22:    expected void *base
drivers/media/rc/st_rc.c:269:22:    got void [noderef] <asn:2>*
drivers/media/rc/st_rc.c:349:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:349:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:349:46:    got void *
drivers/media/rc/st_rc.c:350:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:350:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:350:46:    got void *
drivers/media/rc/st_rc.c:371:61: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:371:61:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:371:61:    got void *
drivers/media/rc/st_rc.c:372:54: warning: incorrect type in argument 2 (different address spaces)
drivers/media/rc/st_rc.c:372:54:    expected void volatile [noderef] <asn:2>*addr
drivers/media/rc/st_rc.c:372:54:    got void *

Regards,
Mauro
