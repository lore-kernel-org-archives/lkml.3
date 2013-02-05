Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3BECEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:04:04 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:47841 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3BECEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <51105F16.8070603@kickflop.net>
References: <51105F16.8070603@kickflop.net>
Date: Mon, 4 Feb 2013 20:03:58 -0600
Message-ID: <CAH2r5mvbbuo9e30kuRFp9eegJqq_9HLR9=oaGvFqyMi-aBKXTQ@mail.gmail.com>
Subject: Re: Read speed
From: Steve French <smfrench@gmail.com>
To: Jeff Blaine <jblaine@kickflop.net>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You will need a more recent kernel (probably based on the 3.2 kernel
or later, 3.2 was released a year or so ago) to see the dramatic
improvements in cifs read speeds (with the redesign of the read code
to add more parallelism on i/o to the same file) although RedHat may
have backported some of Jeff's excellent performance improvements to
some of the older distros.  See slides 21 through 26 of my
presentation at

 http://www.snia.org/sites/default/files2/SDC2012/presentations/Revisions/SteveFrench_Linux_CIFS-SMB2-year-in-review-revision.pdf

Slides 23 and 24 list the cifs performance and functional enhancements
by kernel release.  Buffered, sequential read (e.g. file copy from a
server) got much faster in 3.2 kernel, especially to Samba and other
server which support the Unix extensions (due to support for larger
i/o sizes than 64K).

Similarly note that cifs write speed was dramatically improved
starting at kernel version 3.0 (1.5 to 2 years ago) due to the
addition of more async parallelism to the design of the cifs write
code (writing to the server from the cifs client) by making the i/o
sizes larger and allowing more async dispatch of writes (previously to
use a network interface fully you would need to be reading and or
writing to multiple different files simultaneously).

On Mon, Feb 4, 2013 at 7:23 PM, Jeff Blaine <jblaine@kickflop.net> wrote:
> Hi,
>
> On a RHEL 6.3 box talking to a Windows 7 Enterprise box,
> I am seeing approximately 1/4th the speed with mount.cifs
> as I am with smbclient 'get'. RHEL 6.3 currently has
> CIFS 1.68.
>
> After about a half hour of reading forum threads for the
> last few years, it seems this is very well known and has
> been the case for a long time.
>
> I have tried using CIFSMaxBufSize=61440 with rsize=61140
> at mount-time and it doesn't really buy me much.
>
> Is there any sort of public-facing summary of the state of
> the read performance issues. I saw no mention of it in the
> BUGS section of the mount.cifs man page or in the README for
> the kernel module.
>
> Is the cause known?
>
> Has already been fixed since 1.68 by chance? If so,
> what assembly of pieces will overcome the issue? Should
> I just open a RHEL bug through our support channel and
> get them involved in this effort somehow?
>
> Any guidance would be welcome at this point.
>
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
