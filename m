Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbaE2Q3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:29:45 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:42418 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbaE2Q3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:29:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140529162307.GL18016@ZenIV.linux.org.uk>
References: <20140528141937.GZ18016@ZenIV.linux.org.uk>
	<20140528183954.GA18016@ZenIV.linux.org.uk>
	<20140529031149.GE18016@ZenIV.linux.org.uk>
	<20140529035233.GF18016@ZenIV.linux.org.uk>
	<20140529053444.GI18016@ZenIV.linux.org.uk>
	<20140529105107.GB1938@lahna.fi.intel.com>
	<20140529110439.GA2006@lahna.fi.intel.com>
	<20140529133036.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
	<20140529154454.GK18016@ZenIV.linux.org.uk>
	<20140529162307.GL18016@ZenIV.linux.org.uk>
Date: Thu, 29 May 2014 09:29:42 -0700
X-Google-Sender-Auth: n9VRHhVcA92q4pAbDnjuTuYvAiw
Message-ID: <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 9:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, lock_parent() might be better off if in contended case it would not
> bother with rename_lock and did something like this:
> again:

Ack. I think that's much better.

             Linus
