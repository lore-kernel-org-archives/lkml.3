Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3LQQoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:44:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51780 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3LQQoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:44:13 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 17 Dec 2013 08:44:03 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
Message-ID: <20131217164403.GD1062@leaf>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
 <20131217111920.GA30592@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131217111920.GA30592@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 12:19:21PM +0100, Borislav Petkov wrote:
> On Tue, Dec 17, 2013 at 04:38:16PM +0530, Rashika Kheria wrote:
> > Include appropriate header file ide-cd.h in ide-cd_verbose.c because
> > function ide_cd_log_error() has its prototype declaration in ide-cd.h.
> > Also, include linux/ide.h because it contains certain declarations
> > necessary for including ide-cd.h.
> > 
> > This eliminates the following warnings in ide-cd_verbose.c:
> > drivers/ide/ide-cd_verbose.c:251:6: warning: no previous prototype for ‘ide_cd_log_error’ [-Wmissing-prototypes]
> 
> drivers/ide/ is open only to fixes for serious, real bugs - nothing
> else. I wouldn't waste my time with it if I were you.

A quick check of "git log drivers/ide/" turns up a pile of fixes and
cleanups; for instance:

c2f7d1e ide: pmac: remove unnecessary pci_set_drvdata()
a6fd6063 ide: cs5536: use module_pci_driver()
58e48be ide: pmac: Remove casting the return value which is a void pointer
64110c1 ide: sgiioc4: Staticize ioc4_ide_attach_one()
70ddce8 ide: palm_bk3710: add missing __iomem annotation

The two proposed patches here are extremely low risk, don't actually
change the compiled code in any way like some of those did, and fix real
compiler warnings.

- Josh Triplett
