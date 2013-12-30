Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3L3MmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:42:04 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49593 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab3L3MmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:42:02 -0500
MIME-Version: 1.0
In-Reply-To: <52C14889.7000700@gmail.com>
References: <52C14889.7000700@gmail.com>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Mon, 30 Dec 2013 20:41:41 +0800
Message-ID: <CAE8XmWosaRDW=AOtbC0d_GAquPtzEZq7M4TgwzMNQUx_uz8HSQ@mail.gmail.com>
Subject: Re: man-pages-3.55 is released
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Excerpt from http://man7.org/linux/man-pages/man2/socket.2.html :

       Some socket types may not be implemented by all protocol families;
       for example, SOCK_SEQPACKET is not implemented for AF_INET.

This is not correct now, as Linux already had SCTP support.

Excerpt from http://tools.ietf.org/html/rfc6458#section-3.1.1 :

   and one uses PF_INET or PF_INET6 as the domain, SOCK_SEQPACKET as the
   type, and IPPROTO_SCTP as the protocol.

   Here, SOCK_SEQPACKET indicates the creation of a one-to-many style
   socket.

Regards,
Dongsheng

On Mon, Dec 30, 2013 at 6:18 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Gidday,
>
> I've released man-pages-3.55 - man pages for Linux.
>
> Tarball download:
>     http://www.kernel.org/doc/man-pages/download.html
> Git repository:
>     https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
> Online changelog:
>     http://man7.org/linux/man-pages/changelog.html#release_3.55
>
> A short summary of the release is blogged at:
> http://linux-man-pages.blogspot.com/2013/12/man-pages-355-is-released.html
>
> The current version of the pages is browsable at:
> http://man7.org/linux/man-pages/
>
> A few changes in this release that may be of interest to readers of
> this list are given below.
>
> Cheers,
>
> Michael
>
> ==================== Changes in man-pages-3.55 ====================
>
> Changes to individual pages
> ---------------------------
>
> fallocate.2
>     Christoph Hellwig
>         Clarify the zeroing behavior
>             fallocate() zeroes only space that did not previously contain
>             data, but leaves existing data untouched.
>
> perf_event_open.2
>     Vince Weaver
>         Linux 3.12 rdpmc/mmap
>             It turns out that the perf_event mmap page rdpmc/time setting was
>             broken, dating back to the introduction of the feature.  Due
>             to a mistake with a bitfield, two different values mapped to
>             the same feature bit.
>
>             A new somewhat backwards compatible interface was introduced
>             in Linux 3.12.  A much longer report on the issue can be found
>             here:
>                https://lwn.net/Articles/567894/
>     Vince Weaver
>         Linux 3.12 adds PERF_SAMPLE_IDENTIFIER
>             A new PERF_SAMPLE_IDENTIFIER sample type was added in Linux 3.12.
>     Vince Weaver
>         E2BIG documentation
>             The following documents the E2BIG error return for
>             perf_event_open().
>
>             I actually ran into this error the hard way and it took me
>             half a day to figure out why my ->size value was changing.
>     Vince Weaver
>         Linux 3.12 adds PERF_EVENT_IOC_ID
>             A new perf_event related ioctl, PERF_EVENT_IOC_ID, was added
>             in Linux 3.12.
>     Vince Weaver
>         PERF_COUNT_SW_DUMMY support
>             Support for the PERF_COUNT_SW_DUMMY event type was added in
>             Linux 3.12.
>     Vince Weaver  [Andreas Sandberg]
>         PERF_EVENT_IOC_PERIOD update
>             The PERF_EVENT_IOC_PERIOD ioctl was broken until 2.6.36,
>             and it turns out that the ARM architecture has some
>             differing behavior too.
>
> stat.2
>     Michael Kerrisk
>         Note filesystem support for nanosecond timestamps
>             Add some detail on which native filesystems do and don't
>             support nanosecond timestamps.
>     Michael Kerrisk  [Yang Yang]
>         Update discussion of nanosecond timestamps
>             The existing text describes the timestamp fields as 'time_t'
>             and delegates discussion of nanosecond timestamps under NOTES.
>             Nanosecond timestamps have been around for a while now,
>             and are in POSIX.1-2008, so reverse the orientation of the
>             discussion, putting the nanosecond fields into DESCRIPTION
>             and detailing the historical situation under NOTES.
>
> tty_ioctl.4
>     Michael Kerrisk  [Liu Jiaming]
>         Note that 'arg' should be 0 in the usual case when using TIOCSCTTY
>
> proc.5
>     Michael Kerrisk
>         Document /proc/sys/kernel/ngroups_max
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
