Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3CVABv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:01:51 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:38755 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3CVABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
References: <20130321192935.GY21522@ZenIV.linux.org.uk>
	<CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
	<20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
Date: Thu, 21 Mar 2013 17:01:49 -0700
X-Google-Sender-Auth: Ba3URKzKc35s455kZBPoV4k01bI
Message-ID: <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 4:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So yes, it's against the rules, and we get that deadlock right now,
> but one solution would be to just allow this particular case. The
> patch for the deadlock looks dead simple:

It should go without saying that that whitespace-damaged patch is
entirely untested. But especially since we need to back-port whatever
fix, it would be good if we could make the fix be something as simple
as this. Because I don't believe we really want to backport some big
network-namespace reorganization.

This is, of course, all assuming that hardlinked directories are ok if
we can just guarantee the absence of loops. If there's some other
reason why they'd be problematic, we're screwed.

        Linus
