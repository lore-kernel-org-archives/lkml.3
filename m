Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3KVDA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:00:27 -0500
Received: from ozlabs.org ([203.10.76.45]:59398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3KVDA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:00:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Raphael Hertzog <hertzog@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Some kernel module options not showing up in modinfo
In-Reply-To: <20131121144758.GA6515@x230-buxy.home.ouaza.com>
References: <20131121144758.GA6515@x230-buxy.home.ouaza.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 22 Nov 2013 13:06:46 +1030
Message-ID: <87li0hyxfl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raphael Hertzog <hertzog@debian.org> writes:
> Hello,
>
> I noticed that some options are not visible in the modinfo output. For
> instance "modinfo lockd" reports this on my Debian sid system:
>
> $ modinfo lockd
> filename:       /lib/modules/3.11-1-amd64/kernel/fs/lockd/lockd.ko
> license:        GPL
> description:    NFS file locking service version 0.5.
> author:         Olaf Kirch <okir@monad.swb.de>
> depends:        sunrpc
> intree:         Y
> vermagic:       3.11-1-amd64 SMP mod_unload modversions 
> parm:           nsm_use_hostnames:bool
> parm:           nlm_max_connections:uint
> $
>
> Yet I know that there are more options and the kernel source code confirms
> this:
> http://lxr.free-electrons.com/source/fs/lockd/svc.c#L569
>
> Multiple other options are defined by way of module_param_call(...) like
> nlm_grace_period, nlm_timeout, nlm_updport, nlm_tcpport.
>
> Ben Hutchings (one of the Debian kernel maintainers) confirmed me that
> this was unexpected and suggested me to report it to you. If you have any
> questions, just ask.

Yes, the module_param() macro adds a type description.  The
module_param_call() does not.

Hope that helps,
Rusty.
