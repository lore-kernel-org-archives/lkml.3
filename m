Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaFDXBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:01:01 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35833 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaFDXA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:00:59 -0400
From: Peter Moody <pmoody@google.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>
Subject: Re: splat in kretprobe in get_task_mm(current)
References: <r3noay9dhad.fsf@perdido.sfo.corp.google.com>
	<r3nfvjld5il.fsf@perdido.sfo.corp.google.com> <538ED2E3.1000707@hitachi.com>
	<538F2837.3080800@hitachi.com> <r3nd2eobswp.fsf@perdido.sfo.corp.google.com>
	<538FA28F.30407@hitachi.com>
Date: Wed, 04 Jun 2014 16:00:13 -0700
In-Reply-To: <538FA28F.30407@hitachi.com> (Masami Hiramatsu's message of "Thu\,
	05 Jun 2014 07\:49\:51 +0900")
Message-ID: <r3nha409t6q.fsf@perdido.sfo.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jun 04 2014 at 15:49, Masami Hiramatsu wrote:

> Here, as you can see, calling mmput() in kretprobe handler is actually the root cause
> of this problem.

Indeed, deferring the mmput to a workqueue solved my issue.

Thanks for your quick reply today!

Cheers,
peter
