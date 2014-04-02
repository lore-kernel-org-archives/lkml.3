Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbaDBMRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:17:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60569 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbaDBMRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:17:00 -0400
X-Nat-Received: from [202.181.97.72]:55170 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1396441018.1103
To: struan.bartlett@gmail.com, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        netdev@vger.kernel.org, davem@davemloft.net, nikolay@redhat.com,
        andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        jiri@resnulli.us, joe@perches.com, alonid@postram.com
Subject: Re: [PATCH v2] netconsole: Add tty driver
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <533B2F03.6060008@gmail.com>
In-Reply-To: <533B2F03.6060008@gmail.com>
Message-Id: <201404022116.HIB82683.FOJMFFHVStOLOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 2 Apr 2014 21:16:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 02042014 #7733682, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struan Bartlett wrote:
> Adds tty driver to netconsole module. When module is loaded,
> creates /dev/netcon0 device and enables support for console=netcon0
> kernel cmdline option, causing /dev/console output to be sent to
> /dev/netcon0. This allows startup/shutdown script output from
> headless platforms to be logged over (secure) network.

Excuse me, but I think that the netconsole logging can work only during network
interfaces (e.g. eth0) are up. Did this patch description assume that the
network interfaces are up before the startup script is started and the shutdown
script is finished before the network interfaces are down?

By the way, I uploaded a logger specialized for receiving netconsole messages
to http://sourceforge.jp/projects/akari/scm/svn/tree/head/branches/udplogger/ .
The shortage of netconsole approach compared to serial console approach is that
the netconsole logging cannot work if the network interfaces are down. If we
could log kernel messages via the netconsole module while initializing kdump
kernel by adding console=netcon0 to kdump kernel's command line, we can utilize
netconsole as an alternative tool for logging kernel messages in case
initialization of kdump kernel fails.
