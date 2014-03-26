Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaCZM0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:26:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaCZM0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:26:05 -0400
Date: Wed, 26 Mar 2014 05:27:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: chad@dahc.us, viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: silicom: hide conditionally used function in
 condition
Message-ID: <20140326122748.GB28816@kroah.com>
References: <1395813530-2684-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395813530-2684-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 02:58:50PM +0900, SeongJae Park wrote:
> bp_proc_create() be called only when BP_PROC_SUPPORT defined but its
> definition live outside of #ifdef BP_PROC_SUPPORT and cause following
> trivial build warning:
> drivers/staging/silicom/bpctl_mod.c:6786:12: warning:
> ‘bp_proc_create’ defined but not used [-Wunused-function]
>  static int bp_proc_create(void)
>             ^
> 
> Fix the warning by hide the definition inside #ifdef BP_PROC_SUPPORT.

But no one can define that value, so why add more usages, it should just
be ripped out.  Just remove everything "hidden" by this option as no
one is obviously using it, and no driver should be messing around in
/proc anyway.

thanks,

greg k-h
