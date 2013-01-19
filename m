Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3ASSvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 13:51:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47138 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752138Ab3ASSvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 13:51:04 -0500
Message-ID: <1358621462.2108.3.camel@joe-AO722>
Subject: Re: [PATCH 20/21] ntb_netdev: improve logging
From: Joe Perches <joe@perches.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 19 Jan 2013 10:51:02 -0800
In-Reply-To: <1358586155-23322-21-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
	 <1358586155-23322-21-git-send-email-jon.mason@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-19 at 02:02 -0700, Jon Mason wrote:
> Improve driver logging to be more helpful
[]
> diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
[]
> @@ -408,6 +408,5 @@ static void __exit ntb_netdev_exit_module(void)
>  {
>  	ntb_unregister_client(&ntb_netdev_client);
>  	ntb_unregister_client_dev(KBUILD_MODNAME);
> -	pr_info("%s: Driver removed\n", KBUILD_MODNAME);

It's almost always true that using
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include

and changing all pr_<level>( uses from

	pr_<level>("s: etc...", KBUiLD_MODNAME, ...)
to
	pr_<level>("etc...", ...)

produces overall smaller object code.
That's even more likely for 64 bit compiled code.

