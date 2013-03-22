Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3CVATz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:19:55 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52817 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3CVATy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwd=oTFEfryRs6FgDDHmcw1TM=YkkiDrcWrz-zuFpB26w@mail.gmail.com>
References: <20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<20130322000803.GG21522@ZenIV.linux.org.uk>
	<CA+55aFwd=oTFEfryRs6FgDDHmcw1TM=YkkiDrcWrz-zuFpB26w@mail.gmail.com>
Date: Thu, 21 Mar 2013 17:19:53 -0700
X-Google-Sender-Auth: 4vD7fGzhHKHrgfFVepB3maKsLeU
Message-ID: <CA+55aFxSehUm6CSR=2edeK4STXhV6OWmZrmrGhLOsORXq-D8sw@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thinking some more..

On Thu, Mar 21, 2013 at 5:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. But again, that can't actually happen here. We're in /proc. You
> can't move the entries around.

.. this wasn't a good argument, because we will take the locks before
we do that.

> Also, we only changed the locking order
> for the "inode is identical" case where we take only *one* lock, we
> didn't change it for the cases where we take multiple locks (and order
> them topologically).

.. and this isn't a good argument either, because your argument was
that you can get the deadlock by always taking two directories, and
never hitting the alias case itself.

Hmm.

             Linus
