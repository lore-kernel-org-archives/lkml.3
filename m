Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaFTPXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:23:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40895 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbaFTPXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:23:20 -0400
Date: Fri, 20 Jun 2014 17:23:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
Message-ID: <20140620152312.GB11391@pd.tnic>
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:28:13AM -0400, Boris Ostrovsky wrote:
> Commit 9c15a24b038f4d8da93a2bc2554731f8953a7c17 (x86/mce: Improve
> mcheck_init_device() error handling) unregisters (or never registers)
> MCE's hotplug notifier if an error is encountered.

Well, mcheck_init_device() did encounter errors before that commit too,
can you please go into detail on how exactly you're triggering this?
Which error are you talking about exactly?

Lemme guess: some xen special handling which baremetal doesn't need.

> Since unplugging a CPU would normally result in the notifier deleting
> MCE timer we are now left with the timer running if a CPU is removed on
> a system where mcheck_init_device() had failed.
> 
> If we later hotplug this CPU back we add this timer again in
> mcheck_cpu_init()). Eventually the two timers start intefering with each
> other, causing soft lockups or system hangs.
> 
> We should leave the notifier always on and, in fact, set it up early
> during the boot.

We do leave it always on - we only unregister it if we've encountered an
error.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
