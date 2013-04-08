Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936395Ab3DHWph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:45:37 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63360 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936127Ab3DHWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:45:33 -0400
MIME-Version: 1.0
In-Reply-To: <516341ED.5060803@wwwdotorg.org>
References: <515DB465.1060004@sgi.com>
	<20130404204459.GU21522@ZenIV.linux.org.uk>
	<515F0456.9040803@sgi.com>
	<20130405173623.GE4068@ZenIV.linux.org.uk>
	<515F3A71.9080008@sgi.com>
	<20130405210042.GH4068@ZenIV.linux.org.uk>
	<5162E36F.5020305@sgi.com>
	<20130408155847.GS4068@ZenIV.linux.org.uk>
	<51632DF8.2080402@sgi.com>
	<20130408212327.GU4068@ZenIV.linux.org.uk>
	<20130408214834.GV4068@ZenIV.linux.org.uk>
	<516341ED.5060803@wwwdotorg.org>
Date: Mon, 8 Apr 2013 15:45:31 -0700
X-Google-Sender-Auth: y8GO5aza1GlI66EzokDmcSC-PW0
Message-ID: <CAD=FV=WodJER2g45u5pEw0edf+K4uYJjyt0w4ZfX9q=o1a7pYw@mail.gmail.com>
Subject: Re: hangs on boot in 9984d7394618df9
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nathan Zimmer <nzimmer@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 8, 2013 at 3:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> Anyway, I've just pushed a splitup of that commit (carved in 3 pieces)
>> into vfs.git#pipe-splitup; could you check which part triggers that
>> hang?  Should propagate in a few...
>
> It looks like "pipe: unify ->release() and ->open()" introduces the
> problem. Note that I had to add a prototype for fifo_open() before the
> structs that reference it for that commit to compile.

It sounds like Stephen has provided you the info you needed so not
doing any extra testing now, but I figured I'd chime in that I hit
problems this morning with linux-next and it appears to be the same
thing.  I did a revert of 9984d7394618df9 and (plus a revert of a
handful of patches to the same file) and problems are resolved.  The
failure case is really weird in that everything works well booting to
a simple /bin/bash but fails when you do more complex tasks.

Anyway: If you need some extra testing feel free to CC me.

-Doug
