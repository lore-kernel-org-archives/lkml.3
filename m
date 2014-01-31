Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaAaJqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 04:46:23 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:60716 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbaAaJqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 04:46:21 -0500
Date: Fri, 31 Jan 2014 09:46:15 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Michel Lespinasse <walken@google.com>
Cc: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 1/2] firmware: fix google/gsmi duplicate
 efivars_sysfs_init()
Message-ID: <20140131094615.GB29136@console-pimps.org>
References: <1390914382-3285-1-git-send-email-walken@google.com>
 <1390914382-3285-2-git-send-email-walken@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390914382-3285-2-git-send-email-walken@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan, at 05:06:21AM, Michel Lespinasse wrote:
> Starting in commit e14ab23dde12b80db4c94b684a2e485b72b16af3,
> efivars_sysfs_init() is called both by itself as an init function,
> and by drivers/firmware/google/gsmi.c gsmi_init().
> 
> This results in runtime warnings such as the following:
> [    5.651330] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one+0xbd/0xe0()
> [    5.657699] sysfs: cannot create duplicate filename '/firmware/gsmi/vars'
> 
> Fixing this by removing the redundant efivars_sysfs_init() call in
> gsmi_init().
> 
> Tested: booted, checked that /firmware/gsmi/vars was still present and
> showed the expected contents.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  drivers/firmware/google/gsmi.c | 7 -------
>  1 file changed, 7 deletions(-)

Oops, my bad.

(If it matters: Acked-by: Matt Fleming <matt.fleming@intel.com>)

-- 
Matt Fleming, Intel Open Source Technology Center
