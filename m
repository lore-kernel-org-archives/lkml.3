Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab3BTQkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:40:39 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:62427 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab3BTQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:40:38 -0500
Message-ID: <5124FC82.5040305@suse.cz>
Date: Wed, 20 Feb 2013 17:40:34 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Bryan Mason <bmason@redhat.com>
Subject: Re: [PATCH] TTY: do not reset master's packet mode
References: <1358288782-2946-1-git-send-email-jslaby@suse.cz> <20130220131903.GA8501@x2.net.home>
In-Reply-To: <20130220131903.GA8501@x2.net.home>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 02:19 PM, Karel Zak wrote:
> On Tue, Jan 15, 2013 at 11:26:22PM +0100, Jiri Slaby wrote:
>> Now that login from util-linux is forced to drop all references to a
>> TTY which it wants to hangup (to reach reference count 1) we are
>> seeing issues with telnet. When login closes its last reference to the
>> slave PTY, it also resets packet mode on the *master* side. And we
>> have a race here.
> 
> [...]
> 
>> By this I am resurrecting an old bug, see References. We are hitting
>> it regularly now, i.e. with updated util-linux, ergo login.
>>
>> Here, I am changing a behavior introduced back in 2.1 times. It would
>> better have a long time testing before goes upstream.
> 
>  It would be nice to found a quick way how to resolve this problem,
>  because telnet+login is broken now... and for end users it seems like
>  a regression.

Oh, the patch is in the TTY tree and I suppose it will go to 3.9-rc1
(and to stable as we will get to same later -rc -- to have some testing).

>  Maybe the requirement (patch) to close all references to TTY before
>  hangup should reverted or we can make an exception in login(1) code to
>  keep TTY open when login(1) is executed with -h (as used by telned).

If we reverted the patch in login, we would have to revert also a patch
in the TTY which closes a window allowing you to crash a kernel at will
(in fact that patch disallows multiple opens when hanging up a terminal.
IOW only the one to hang the terminal is allowed to have it opened.)

-- 
js
suse labs
