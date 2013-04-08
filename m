Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3DHEdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:33:38 -0400
Received: from ozlabs.org ([203.10.76.45]:53983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3DHEdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:33:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Philip Kranz <philip.kranz@googlemail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>, linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Add non-zero module sections to sysfs
In-Reply-To: <20130406104053.GA24710@yoda.lan>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au> <1365156435.1970.31.camel@dabdike> <20130406104053.GA24710@yoda.lan>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 08 Apr 2013 13:44:45 +0930
Message-ID: <878v4tbqve.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Kranz <philip.kranz@googlemail.com> writes:
> Hello.
>
> On Fri, Apr 05, 2013 at 12:07:15PM +0200, James Bottomley wrote:
>> Just so you know: this isn't a parisc specific problem.  Gcc produces
>> duplicate section names under various circumstances, but the one that
>> bites us is -ffunction-sections.  Note that there are proposals to use
>> -ffunction-sections on all architectures (so we can garbage collect
>> unused functions) in which case you'll induce the bug identified in
>> 35dead4235e2b67da7275b4122fed37099c2f462 on every architecture
>
> I am not able to produce an object file with duplicate section names
> using gcc on x86. Even with -ffunction-sections, every section gets a
> unique name. Is this architecture-specific behaviour of gcc?

Good point.  ld -r will collapse them into the same section (since gcc
produces them they have to have the same section attributes).

You can do it with --unique, but no arch uses that.  PARISC has a
platform-specific toolchain hack which does that for .text sections.
(Thanks to Alan Modra for that clue...)

Thanks,
Rusty.
