Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaDDXrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:47:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaDDXrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:47:19 -0400
Date: Fri, 4 Apr 2014 16:49:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] topology: Fix compilation warning when not in SMP
Message-ID: <20140404234943.GA14633@kroah.com>
References: <1396593798-29173-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396593798-29173-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 08:43:18AM +0200, Vincent Stehlé wrote:
> The topology_##name() macro does not use its argument when CONFIG_SMP is not
> set, as it ultimately calls the cpu_data() macro.
> 
> So we avoid maintaining a possibly unused `cpu' variable, to avoid the
> following compilation warning:
> 
>   drivers/base/topology.c: In function ‘show_physical_package_id’:
>   drivers/base/topology.c:103:118: warning: unused variable ‘cpu’ [-Wunused-variable]
>    define_id_show_func(physical_package_id);
> 
>   drivers/base/topology.c: In function ‘show_core_id’:
>   drivers/base/topology.c:106:106: warning: unused variable ‘cpu’ [-Wunused-variable]
>    define_id_show_func(core_id);
> 
> This can be seen with e.g. x86 defconfig and CONFIG_SMP not set.
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # 3.10.x
> Cc: <stable@vger.kernel.org> # 3.13.x
> Cc: <stable@vger.kernel.org> # 3.14.x

Warnings aren't a stable kernel issue, so why would this be relevant
there?

thanks,

greg k-h
