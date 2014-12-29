Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaL2TmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 14:42:05 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:55247 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaL2TmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 14:42:03 -0500
From: Paul Moore <paul@paul-moore.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux Kernel <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)
Date: Mon, 29 Dec 2014 14:41:59 -0500
Message-ID: <4182091.odzUCAWhED@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54A18046.9060209@gmx.de>
References: <54A17C49.5080102@gmx.de> <CAHC9VhTT1WqGfuOLpXw1o2ZE5Bhwg35KCc1Gg2-bYtFX9jAYRg@mail.gmail.com> <54A18046.9060209@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 29, 2014 05:24:38 PM Toralf Förster wrote:
> On 12/29/2014 05:21 PM, Paul Moore wrote:
> > On Mon, Dec 29, 2014 at 11:07 AM, Toralf Förster wrote:
> >> A x86 KVM guest running at a 64 bit Gentoo hardened host system the
> >> following crashes appeared reproducible (screen shots attached.
> >> 
> >> If I removed syslog-ng from the runlevel default, then the crash just
> >> appeared a little bit later at another subsystem> 
> >
> > It looks like it doesn't like something in audit_compare_dname_path();
> > I'll take a look and see what I can find, there is a patch in -rc2
> > which touched some related code.
> > 
> > I didn't see this problem in my earlier testing, can you share your
> > .config?
>
> ofc - attached

[NOTE: added linux-audit to the CC line, I should have done that earlier]

I believe I can reproduce this now; I'm seeing slightly different panics, but 
it is "close enough" and based on some quality time with the code I believe 
they are both symptoms of the same root cause.

To help verify that I'm heading down the right path, could you share your 
audit configuration as well?  If that's not possible, can you at least confirm 
that you using a few audit directory watches?

-- 
paul moore
www.paul-moore.com

