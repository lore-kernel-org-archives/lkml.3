Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3HXKut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 06:50:49 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33867 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753791Ab3HXKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 06:50:47 -0400
Message-ID: <52189005.30009@hurleysoftware.com>
Date: Sat, 24 Aug 2013 06:50:45 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Finding out who's holding a lock?
References: <CALCETrUobqJKGCma_8=qsG=w3Tm3=ttZB==DwdHyGBkJDBYV_g@mail.gmail.com>
In-Reply-To: <CALCETrUobqJKGCma_8=qsG=w3Tm3=ttZB==DwdHyGBkJDBYV_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 08:52 PM, Andy Lutomirski wrote:
> My program is occasionally seeing slow page faults.  latencytop says
> they're slow because they're waiting for read access to mmap_sem, but
> latencytop isn't showing any other thread in the process blocking.
>
> Is there any straightforward way to find out who called down_write on
> mmap_sem when down_read is slow?

Build with CONFIG_LOCKDEP (Kernel Debugging -> Lock Debugging ->
"Lock Debugging: prove locking correctness").

When you experience the slowdown, sysrq + d (displays all currently
held locks). sysrq can also be programmatically triggered with
"echo d > /proc/sysrq-trigger" or equivalent.

Regards,
Peter Hurley

