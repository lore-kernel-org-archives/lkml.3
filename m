Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaLRL6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:58:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47975 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaLRL6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:58:08 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] video/logo: prevent use of logos after they have been freed
Date: Thu, 18 Dec 2014 13:57:21 +0200
Message-ID: <1418903842-22450-1-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.2.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The fbdev logo seems to be rather messed up when deferred probing is happening.
This is a quick fix for the problem.

The code in the logo.c is quite scary, using __init_refok to silence warnings
about accessing __initdata from non-init context.

Another option would be to make the logos not __initdata, but I think that's
not acceptable.

Any ideas for a nicer way to fix this issue?

 Tomi

Tomi Valkeinen (1):
  video/logo: prevent use of logos after they have been freed

 drivers/video/logo/logo.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

-- 
2.2.0

