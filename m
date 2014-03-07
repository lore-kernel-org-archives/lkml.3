Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaCGOpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:45:06 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47706 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaCGOpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:45:03 -0500
Date: Fri, 7 Mar 2014 18:45:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Artem Fetishev <artem_fetishev@epam.com>, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        wiebittewas@googlemail.com, alexandr_terekhov@epam.com
Subject: Re: [PATCH] proc: #68991 Fix GPF in /proc/$PID/map_files
Message-ID: <20140307144500.GI1852@moon>
References: <20140308022033.GC5690@owamsq.epam.com>
 <5319D7B9.6050000@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5319D7B9.6050000@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:29:13PM +0400, Pavel Emelyanov wrote:
> On 03/08/2014 06:20 AM, Artem Fetishev wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=68991
> > 
> > The expected logic of proc_map_files_get_link() is either to return 0 and
> > initialize 'path' or return an error and leave 'path' uninitialized. By the time
> > dname_to_vma_addr() returns 0 the corresponding vma may have already be gone. In
> > this case the path is not initialized but the return value is still 0. This
> > results in 'general protection fault' inside d_path().
> > 
> > Steps to reproduce:
> > CONFIG_CHECKPOINT_RESTORE=y
> > 
> > fd = open(...);
> > while (1) {
> > 	mmap(fd, ...);
> > 	munmap(fd, ...);
> > }
> > 
> > ls -la /proc/$PID/map_files
> > 
> > Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
> > Signed-off-by: Aleksandr Terekhov <aleksandr_terekhov@epam.com>
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>

Good catch, thanks!

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

I suppose this is a stable@ material.
