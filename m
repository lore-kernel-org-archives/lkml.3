Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaJNWNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:13:39 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:34616 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbaJNWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:13:37 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXNbrLd6BbCPUPXiPc57JDzfwWTjOrU9cx_nWoORPeyCQ@mail.gmail.com>
References: <d4c63d6c350d26ffc985d061d213bd778055ca5b.1413322603.git.luto@amacapital.net>
 <87tx36l3gp.fsf@x220.int.ebiederm.org> <CALCETrXNbrLd6BbCPUPXiPc57JDzfwWTjOrU9cx_nWoORPeyCQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Oct 2014 15:13:16 -0700
Message-ID: <CALCETrWzWUtobC-SRX0o5aOHPEfTJ0A2a8AKZh6u2zL0DNP=ZA@mail.gmail.com>
Subject: Re: [PATCH] fs: Treat non-ancestor-namespace mounts as MNT_NOSUID
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 3:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Oct 14, 2014 at 2:57 PM, Eric W. Biederman

>>> Seth, this should address a problem that's related to yours.  If a
>>> userns creates and untrusted fs (by any means, although admittedly fuse
>>> and user namespaces don't work all that well together right now), then
>>> this prevents shenanigans that could happen when the userns passes an fd
>>> pointing at the filesystem out to the root ns.
>>
>> Andy for now I really think we are best not even reading those
>> capabilities into the vfs from unprivileged mounts.
>
> But won't we want to support letting userns containers create setuid
> files and security labels using FUSE and related things for their own
> benefit someday?  This lets us do that without compromising the init
> namespace.

More concretely, root in a userns should be able to have a
setuid-whomever or security-labeled file, and another user in that
userns should be able to exec it and transition.  But, if you're
outside the userns, then:

$ /proc/PID_IN_USERNS/root/path/to/labeled/file

shouldn't transition.

--Andy
