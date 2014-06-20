Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728AbaFTP6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:58:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37491 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932593AbaFTP6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:58:53 -0400
Date: Fri, 20 Jun 2014 17:58:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
Message-ID: <20140620155845.GC11391@pd.tnic>
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
 <20140620152312.GB11391@pd.tnic>
 <53A45627.6090306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A45627.6090306@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:41:27AM -0400, Boris Ostrovsky wrote:
> Only in the sense that on Xen misc_register() often fails. But any
> failure on baremetal will result in the same behavior.

Ok, thanks for explaining the details.

> Right. And I think we shouldn't because we leave undeleted timers.

I wonder if we could simply move the oneliner:

	__register_hotcpu_notifier(&mce_cpu_notifier);

to mcheck_init()? We don't need any locking there because we're pre-SMP
then and from looking at notifier_chain_register(), it seems there's
nothing special that needs initializing for the call to be too early -
we're simply adding the callback to a list...

Hmm, because if that would work, the fix is almost trivial. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
