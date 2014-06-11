Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaFKRiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:38:09 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:56383 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaFKRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <53986DFB.9030006@oracle.com>
References: <5388838B.8070802@oracle.com>
	<53888E76.5040101@hurleysoftware.com>
	<20140530140757.GC2419@quack.suse.cz>
	<53921116.5050804@oracle.com>
	<53972B5C.5020605@hurleysoftware.com>
	<53986DFB.9030006@oracle.com>
Date: Wed, 11 Jun 2014 10:38:05 -0700
X-Google-Sender-Auth: b7vOWr0LJyxn6X6kutZH8cpn__s
Message-ID: <CA+55aFxtxzqMji8csXALz_yiF3XaJBNjsPY66Z2+tL_9U1nrKQ@mail.gmail.com>
Subject: Re: console: lockup on boot
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Jan Kara <jack@suse.cz>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 7:55 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I've ran a bisection again and ended up at the same commit as Jet Chen (the commit
> unfortunately already made it to Linus's tree).

Ok, I'm going to revert that commit.  The games it plays with cpu
numbers and preemption make me worried, and it looks silly.

If the only reason for that patch is interrupt latency, then if the
"preempt_disable()" had been done *before* restoring irq's, none of
those "let's reload the CPU number" games would have been necessary,
and the patch could have been smaller. So even if that is the solution
to the problems people report, it's actually *better* to just revert
the patch entirely, and try again with a smaller and simpler version,
rather than try to change the patch after-the-fact.

          Linus
