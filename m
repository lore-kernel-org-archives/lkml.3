Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3KUOys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:54:48 -0500
Received: from mail.vm.ouaza.com ([88.190.240.227]:57297 "EHLO
	mail.vm.ouaza.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3KUOyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:54:47 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 09:54:47 EST
Date: Thu, 21 Nov 2013 15:47:58 +0100
From: Raphael Hertzog <hertzog@debian.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Some kernel module options not showing up in modinfo
Message-ID: <20131121144758.GA6515@x230-buxy.home.ouaza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed that some options are not visible in the modinfo output. For
instance "modinfo lockd" reports this on my Debian sid system:

$ modinfo lockd
filename:       /lib/modules/3.11-1-amd64/kernel/fs/lockd/lockd.ko
license:        GPL
description:    NFS file locking service version 0.5.
author:         Olaf Kirch <okir@monad.swb.de>
depends:        sunrpc
intree:         Y
vermagic:       3.11-1-amd64 SMP mod_unload modversions 
parm:           nsm_use_hostnames:bool
parm:           nlm_max_connections:uint
$

Yet I know that there are more options and the kernel source code confirms
this:
http://lxr.free-electrons.com/source/fs/lockd/svc.c#L569

Multiple other options are defined by way of module_param_call(...) like
nlm_grace_period, nlm_timeout, nlm_updport, nlm_tcpport.

Ben Hutchings (one of the Debian kernel maintainers) confirmed me that
this was unexpected and suggested me to report it to you. If you have any
questions, just ask.

Cheers,
-- 
Raphaël Hertzog ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ http://debian-handbook.info/get/
