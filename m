Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaJOB1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 21:27:37 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:45386 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbaJOB1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 21:27:36 -0400
Message-ID: <543DCD86.30803@acm.org>
Date: Tue, 14 Oct 2014 20:27:34 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [patch 3/3] ipmi: Unregister previously registered driver in
 error case
References: <20141014144020.683892494@d46.suse.de> <20141014144315.728965695@d46.suse.de>
In-Reply-To: <20141014144315.728965695@d46.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queued, thanks for spotting this.

-corey

On 10/14/2014 09:40 AM, trenn@suse.de wrote:

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: minyard@acm.org

Index: kernel_ipmi/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- kernel_ipmi.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ kernel_ipmi/drivers/char/ipmi/ipmi_msghandler.c
@@ -4545,6 +4545,7 @@ static int ipmi_init_msghandler(void)
 	proc_ipmi_root = proc_mkdir("ipmi", NULL);
 	if (!proc_ipmi_root) {
 	    printk(KERN_ERR PFX "Unable to create IPMI proc dir");
+	    driver_unregister(&ipmidriver.driver);
 	    return -ENOMEM;
 	}
 



