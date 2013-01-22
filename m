Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3AVTdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:33:11 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39526 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab3AVTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:33:07 -0500
MIME-Version: 1.0
In-Reply-To: <1358868049-19884-2-git-send-email-trenn@suse.de>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
	<1358868049-19884-2-git-send-email-trenn@suse.de>
Date: Tue, 22 Jan 2013 11:33:06 -0800
X-Google-Sender-Auth: NQxf8h3JkV1zInn62XfIfDTVvyA
Message-ID: <CAE9FiQXHG_HMuQK=d+vOXNokZnZ1eSmU+V2_50zuWvtJ=ayEWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86 e820: Check for exactmap appearance when parsing
 first memmap option
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 7:20 AM, Thomas Renninger <trenn@suse.de> wrote:
>
> memmap=exactmap will throw away all original, but also until then
> user defined (through other provided memmap= parameters) areas.
> That means all memmap= boot parameters passed before a memmap=exactmap
> parameter are not recognized.
> Without this fix:
> memmap=x@y memmap=exactmap memmap=i#k
> only i#k would get recognized.
>
> This is wrong, this fix will only throw away all original e820 areas once
> when memmap=exactmap is found in the whole boot command line and before
> any other memmap= option is parsed.

Actually I put this patch already in for-x86-boot branch.

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commit;h=bd40ee79abf2351109ebd469b0b9ba6a8f3b0872

And will update change log to following to merge two change log.

---
Subject: [PATCH] x86: Handle multiple exactmaps and out of order exactmap

Current code expect that we only have one exactmap and exactmap need to
first one in memmap=.

memmap=exactmap will throw away all original entries, but also until
then user defined (through other provided memmap= parameters) areas.
That means all memmap= boot parameters passed before a memmap=exactmap
parameter are not recognized.

Without this fix:
        memmap=x@y memmap=exactmap memmap=i#k
only i#k would get recognized.  This is wrong.

This fix will scan the boot_command_line to find if there is exactmap at
first and only throw away all original e820 entries once, and then parse
other memmap= option.

-v2: incorporate change log from Thomas Renninger.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Thomas Renninger <trenn@suse.de>
