Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaBCUYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:24:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaBCUYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:24:17 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] audit: Only use the syscall slowpath when syscall audit rules exist
Date: Mon, 03 Feb 2014 15:23:59 -0500
Message-ID: <1400745.hJLGxDlRLu@x2>
Organization: Red Hat
User-Agent: KMail/4.11.5 (Linux/3.12.9-301.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <a8356e46aed7213128e84a888170391adb6afe30.1391449825.git.luto@amacapital.net>
References: <a8356e46aed7213128e84a888170391adb6afe30.1391449825.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 03, 2014 09:53:23 AM Andy Lutomirski wrote:
> This toggles TIF_SYSCALL_AUDIT as needed when rules change instead of
> leaving it set whenever rules might be set in the future.  This reduces
> syscall latency from >60ns to closer to 40ns on my laptop.

Does this mean that we have processes that don't have the  TIF_SYSCALL_AUDIT 
flag set? When rules get loaded, how do we get the flag put back into all 
processes?

The theory of ops is supposed to be that for anyone not needing audit, there 
is only the cost of  "if (tif & TIF_SYSCALL_AUDIT)". That should be it. If you 
have audit enabled or had it enabled (which means it might be loaded with new 
rules), we want to inspect the syscall. There should be a short circuit based 
on checking that any rules has ever been loaded or are currently loaded before 
doing any real collection.

-Steve


