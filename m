Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaF3QGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:06:02 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64726 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaF3QF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:05:59 -0400
MIME-Version: 1.0
In-Reply-To: <1404124096-21445-10-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <1404124096-21445-10-git-send-email-drysdale@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jun 2014 09:05:38 -0700
Message-ID: <CALCETrUBCL1jKfooLaqrJCb-uYrMwYPQL2v-M04NTVf2LoD_fw@mail.gmail.com>
Subject: Re: [PATCH 09/11] capsicum: implementations of new LSM hooks
To: David Drysdale <drysdale@google.com>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale@google.com> wrote:
> If the LSM does not provide implementations of the .file_lookup and
> .file_install LSM hooks, always use the Capsicum implementations.
>
> The Capsicum implementation of file_lookup checks for a Capsicum
> capability wrapper file and unwraps to if the appropriate rights
> are available.
>
> The Capsicum implementation of file_install checks whether the file
> has restricted rights associated with it.  If it does, it is replaced
> with a Capsicum capability wrapper file before installation into the
> fdtable.

I think I fall on the "no LSM" side of the fence.  This kind of stuff
should be available regardless of selected LSM (as it is in your
code), but until someone has a use case for the LSM hooks in real
LSMs, I don't really see the point.

--Andy
