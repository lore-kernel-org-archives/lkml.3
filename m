Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3GZMno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:43:44 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:35135 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3GZMnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130703014616.18745.34699.stgit@localhost.localdomain>
References: <20130703014616.18745.34699.stgit@localhost.localdomain>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 26 Jul 2013 14:43:21 +0200
Message-ID: <CAPXgP11HzstSBt1PQUgJeGC59yXc=DSYQuruB40LOsm=RZQBZA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Add a hash value for each line in /dev/kmsg
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 3:46 AM, Hidehiro Kawai
<hidehiro.kawai.ez@hitachi.com> wrote:

> This patch series adds hash values of printk format strings into
> each line of /dev/kmsg outputs as follows:
>
>         6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs

/dev/kmsg is to a certain degree a kernel ABI. Having source code
locations in exported log records might cause people / userspace tools
to rely on these strings and expect stability here. The kernel though
cannot make any promises of its source code layout.

The hash is supposed to identify the content of a message, but what if
someone fixes the string? Maybe someone just fixes a one char typo,
the hash will change and the message will not be recognizable any
more.

As much as "automated" hash creation sounds simple; I really think
adding explicit "manually" created random message ids to the bunch of
messages that are interesting is the better option long-term. It
shouldn't be that many messages, most of the printk output is not
really useful for automated inspection or to trigger specific actions.

Messages ideally should not have any direct context to the code that
emits them, they should just identify the message and add a few
structured properties to the message.

This is how userspace identifies log messages and maintains abstract
descriptions of the specific messages to act when they appear:
  http://www.freedesktop.org/wiki/Software/systemd/catalog/

Connecting kernel log message texts and source code locations with
message identifiers looks quite dangerous, hard to keep stable if
things are evolving. It might cause serious problems over time.

Thanks,
Kay
