Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3BLLiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:38:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51599 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab3BLLiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:38:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[2]: [PATCH v2 1/3] mfd: syscon: Removed support for unloading
Date: Tue, 12 Feb 2013 11:38:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1360608173-12907-1-git-send-email-shc_work@mail.ru> <201302112005.35034.arnd@arndb.de> <1360650935.475602112@f368.mail.ru>
In-Reply-To: <1360650935.475602112@f368.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121138.48288.arnd@arndb.de>
X-Provags-ID: V02:K0:iufxISrvGRUo61NQ723WlchuQYsQmC6pcMOIrXKMD7U
 wgiSt6sJNxbcuk4tsEJoLNX6RZMsKAzypAQxh/Y55ao13/ABiF
 hhWURnL518K0L7/sXYqmVumcn8/8VztuMOBItMB75qJUlB+bn2
 f571hs9mP10EOjCsPHtQeWvP2+OWdDZkYQQFaSCa/i/ffmcpWg
 zpIoh3SZdFXf2lfgRlNXst1VFSMSIkFvbHKi9G5amDlEqiBgBr
 r9sEYca6GoLb4dN5Qko2ex3ArIBgP2Za7J9oPnGgiesf8aArYz
 tleuQnenEAoRkbug0ggX/euWzEPWeqsKGJ/YYgTOHdGxVMIKQE
 X/oWbRzEChFBV2vtGWQg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Alexander Shiyan wrote:
> > On Monday 11 February 2013, Alexander Shiyan wrote:
> > > The driver can be used in various subsystems and therefore should not
> > > be unloaded when it is defined in the kernel configuration, so remove
> > > support for unloading it.
> > > 
> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > 
> > Can you describe a scenario where that would happen? Normally the
> > module should stay pinned as long as any other module refers
> > to its exported symbols.
> 
> Probably I wrote a bad description.
> The driver registered by "postcore_initcall". Therefore, if we unregister the
> driver, we have no way to register it back. Fixme please.

Ah, the driver is actually "bool" in Kconfig rather than "tristate", so
it is not possible to build it as a module. Makes sense then, and if 
we ever want to turn this into a module, we can still revert your patch.

	Arnd
