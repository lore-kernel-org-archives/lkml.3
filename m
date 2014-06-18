Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbaFRIgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:36:01 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36200 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbaFRIf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:35:58 -0400
Date: Wed, 18 Jun 2014 09:35:55 +0100
From: Matt Fleming <matt@console-pimps.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
        Matt Fleming <matt.fleming@intel.com>, Madper Xie <cxie@redhat.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pstore: Fix an overflow on 32-bit builds.
Message-ID: <20140618083555.GA24049@console-pimps.org>
References: <1402325440-26335-1-git-send-email-andrew.zaborowski@intel.com>
 <alpine.DEB.2.02.1406091322050.30620@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406091322050.30620@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun, at 01:24:43PM, David Rientjes wrote:
> On Mon, 9 Jun 2014, Andrzej Zaborowski wrote:
> 
> > [resend]
> > In generic_id the long int timestamp is multiplied by 100000 and needs
> > an explicit cast to u64.
> > 
> > Without that the id in the resulting pstore filename is wrong and
> > userspace may have problems parsing it, but more importantly files in
> > pstore can never be deleted and may fill the EFI flash (brick device?).
> > This happens because when generic pstore code wants to delete a file,
> > it passes the id to the EFI backend which reinterpretes it and a wrong
> > variable name is attempted to be deleted.  There's no error message but
> > after remounting pstore, deleted files would reappear.

It shouldn't be possible to brick devices because the efi-pstore code
still goes through efivar_entry_set_safe() whic has the necessary
checks. Please let me know if you've witnessed any fallout from this bug
other than being unable to delete files.

> This fixes commit fdeadb43fdf1 ("efi-pstore: Make efi-pstore return a 
> unique id") that went into stable, so I'm not sure if this should go into 
> stable as well.
 
I think it should go to stable too. Tony?

> You probably had to resend this because you didn't email any of the 
> maintainers (fixed).  Use scripts/get_maintainer.pl to figure out who to 
> email about a patch.

Thanks for triaging this David.

Unless anyone speaks up I'm going to throw this into the EFI tree with
David's Acked-by.

-- 
Matt Fleming, Intel Open Source Technology Center
