Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaBRUSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:18:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaBRUSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:18:00 -0500
Message-ID: <1392754665.2165.33.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no
 rules
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Date: Tue, 18 Feb 2014 15:17:45 -0500
In-Reply-To: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
References: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-08 at 13:06 -0800, Andy Lutomirski wrote:
> This toggles TIF_SYSCALL_AUDIT as needed when rules change instead
> of leaving it set whenever rules might be set in the future.  This
> reduces syscall latency from >60ns to closer to 40ns on my laptop.

Al also politely reminded me it might be wise to get some perf data
about where exactly we are spending out time.  I don't know squat about
perf, but Linus always tells me to do:

perf record -g -e cycles:pp -F 25000 $YOURTEST
perf report -s symbol

(the "-s symbol" is so that you don't get separate data for the
different processes that are part of the kernel build - you'll just
want "general kernel data"), and on one of the kernel symbols just
select it and do "Zoom into kernel DSO". You should see something like
this:

