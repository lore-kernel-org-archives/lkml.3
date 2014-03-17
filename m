Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaCQTtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:49:08 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:43176 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaCQTtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <53274D93.8030105@oracle.com>
References: <1394994799-2221-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFx-4XM3qzbEf1kgSDsuUm22sWCYHVaqK2D+juvHY3WEeg@mail.gmail.com>
	<53274D93.8030105@oracle.com>
Date: Mon, 17 Mar 2014 12:49:04 -0700
X-Google-Sender-Auth: 6gu1wdMbjJSDENvzhmAq7qoqVt0
Message-ID: <CA+55aFzzDDNLc3NzDSJ1q3ctyVJK9FXyCUxzBwQeoUHR94BLnA@mail.gmail.com>
Subject: Re: [PATCH] improve_stack: make stack dump output useful again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 12:31 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> What about duplicate symbol names? Without the full hex address we lose
> the ability to correctly translate from symbol name to file/line.

Yeah, and we should strive to avoid that issue.

The thing is, think about address randomization. We can pretty much
assume that is going to be the standard behavior due to it being
really cheap (just a trivial boot time cost), and helping some
security issues.

So we might have a few ambiguous cases, that's still better than the
alternative.

                Linus
