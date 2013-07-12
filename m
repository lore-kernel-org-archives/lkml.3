Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab3GLMDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:03:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:60443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928Ab3GLMDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:03:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [git pull] vfs.git part 2
Date: Fri, 12 Jul 2013 12:02:45 +0000
Organization: D03
Message-ID: <8738rk9eai.fsf@rasmusvillemoes.dk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
	<CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
	<20130712054817.GY4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-34.imf.au.dk
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Cancel-Lock: sha1:VQywk+gqnBeWVNXWouYDQ95mPMs=
Cc: linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Thu, Jul 11, 2013 at 02:42:54PM -0700, Linus Torvalds wrote:
>> But with an *old* kernel, O_TMPFILE will just silently be ignored as
>> an unrecognized flag, and things won't work. If you do
>> 
>>   fd = open("dirname", O_CREAT | O_TMPFILE | O_RDWR, 0666);
>> 
>> it may be that it ends up acting as a "create file at specified
>> directory path" instead of what the user *meant* for it to do, which
>> was "create unnamed temporary file in the specified directory".
>> 
>
> It's slightly less painful than that - if dirname exists, the old kernels
> will fail; O_CREAT for existing directory means an error.

But isn't the problem the case where dirname does not exist? I.e., the
application has to make sure that "/some/where" exists and is a directory
before open("/some/where", O_CREAT | O_TMPFILE | O_RDWR, 0666) can be
relied upon to fail on kernels not recognizing O_TMPFILE, instead of
just creating "where" in "/some".

Just thinking out loud, and please tell me to shut up if it doesn't make
sense: The documentation for O_DIRECTORY seems to imply that one could
require O_DIRECTORY to be given when using O_TMPFILE. The "If pathname
is not a directory, cause the open to fail" certainly seems to make
sense when O_TMPFILE is used, and older kernels should complain when
seeing the O_CREAT|O_DIRECTORY combination. It is a hack, though.

Rasmus

