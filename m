Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3EKVM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 17:12:28 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:39765 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3EKVM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 17:12:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130511210641.GQ25399@ZenIV.linux.org.uk>
References: <20130509050343.GD25399@ZenIV.linux.org.uk>
	<CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
	<20130511172242.GP25399@ZenIV.linux.org.uk>
	<CA+55aFzsgr6ZHWxNRvM3VZu=bWn75TfGb0EAXO1wdFnBFTCz-Q@mail.gmail.com>
	<20130511210641.GQ25399@ZenIV.linux.org.uk>
Date: Sat, 11 May 2013 14:12:25 -0700
X-Google-Sender-Auth: uUiGuZXVKKHPXcDUTeEQm_D3eMg
Message-ID: <CA+55aFy8Y9w0OBHLTqHxjLLXZXOSf+d5YJ-huNaMOs3V5DycCA@mail.gmail.com>
Subject: Re: [RFC] next cycle fun: ->release() API change
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 2:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Less boilerplate?  We used to pass inode to fput() as well, but
> switched to passing file alone...

.. and that was painful.

The advantage has to be balanced against the pain it causes. I'm not
seeing the advantage here as being worth it. If this kind of thing not
only causes way more churn, _and_ it causes us to pick a new (worse)
name just because it also forces a non-compatible ABI, I'm really
doubtful.

I mean, if we had *other* reasons for the churn, and the name needed
to change anyway, then maybe, but..

             Linus
