Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbaDJSPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:15:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44553 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758938AbaDJSPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:15:11 -0400
Date: Thu, 10 Apr 2014 20:15:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: df36ac1bc2a16 ("pstore: Don't allow high traffic options on fragile
 devices")
Message-ID: <20140410181503.GA4704@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tony,

so I was wondering whether we could finally put that UEFI thing to use
and log dmesg into it but then Matt pointed me to df36ac1bc2a16.

Even though those nvram devices are fragile and can only stomach a
limited amount of writes, wouldn't it be a nifty feature to have a
kernel cmdline param of the sort "put_dmesg_in_nvram_this_one_time_only"
which logs to nvram only once for debugging purposes.

The usecase I have in mind is all those laptops which are sporting UEFI
now and where logging to serial or netconsole or something else is
simply not an option, for whatever reason (I'm sure anyone can think of
a number of those). If we had this, it would be one step closer to the
holy grail of being able to catch dmesg even on laptops.

We could also add checks like if efivarfs already has a dump-type* file
to not log, etc etc. Eventually, it would be a user decision whether to
still log to nvram or not, i.e. brick her laptop or not.

Thoughts?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
