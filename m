Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3GLW1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:27:54 -0400
Received: from ar100.montanavision.com ([216.146.103.100]:36803 "EHLO
	xilka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757776Ab3GLW1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:27:52 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jul 2013 18:27:52 EDT
Message-ID: <51E080DC.5040109@xilka.com>
Date: Fri, 12 Jul 2013 16:19:08 -0600
From: Kelly Anderson <kelly@xilka.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130702 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH]: 3.10 fails to boot from mmc root
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10 fails to boot from mmc root without this patch.

An early version of this patch was to be included in in 3.10
but apparently didn't make it.

--- ./drivers/mmc/core/core.c.orig    2013-06-30 16:13:29.000000000 -0600
+++ ./drivers/mmc/core/core.c    2013-07-12 15:17:15.377466795 -0600
@@ -2421,6 +2421,7 @@ void mmc_start_host(struct mmc_host *hos
      else
          mmc_power_up(host);
      mmc_detect_change(host, 0);
+    mmc_flush_scheduled_work();
  }

  void mmc_stop_host(struct mmc_host *host)

