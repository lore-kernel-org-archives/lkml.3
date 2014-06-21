Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537AbaFUKJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:09:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44662 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807AbaFUKJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:09:04 -0400
Date: Sat, 21 Jun 2014 12:08:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
Message-ID: <20140621100854.GA25200@pd.tnic>
References: <20140620155845.GC11391@pd.tnic>
 <53A45E67.7070000@oracle.com>
 <20140620175240.GE11391@pd.tnic>
 <53A48DF6.9020503@oracle.com>
 <20140620200358.GK11391@pd.tnic>
 <53A496B2.2090701@oracle.com>
 <20140620202900.GL11391@pd.tnic>
 <53A49CF9.3050400@oracle.com>
 <20140620211115.GO11391@pd.tnic>
 <53A4E835.3090907@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A4E835.3090907@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:04:37PM -0400, Boris Ostrovsky wrote:
> I'll try it later but this doesn't look sufficient to me: we might not
> reach this point if subsys_system_register() or zalloc_cpumask_var()
> fail.

If those fail, I'd say we have a much bigger problem than undeleted
timers.

> We could register the notifier as the first thing in this routine
> (probably after mce_available() succeeds).

I guess...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
