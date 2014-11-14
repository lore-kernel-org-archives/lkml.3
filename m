Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530AbaKNNU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:20:56 -0500
Received: from mail-yk0-f181.google.com ([209.85.160.181]:60915 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865AbaKNNUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAD6G_RREb58La-pC48BHW+9r9oruUXnCrk-RS8LaKSw6y9jgxg@mail.gmail.com>
References: <CAD6G_RREb58La-pC48BHW+9r9oruUXnCrk-RS8LaKSw6y9jgxg@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 14 Nov 2014 07:20:33 -0600
Message-ID: <CAAMCDec3EJ4e=bDKwH3i0PL655yrOQkBu_typihYMGD3GHZiQA@mail.gmail.com>
Subject: Re: read performance is too low compared to write - /dev/sda1
To: Jagan Teki <jagannadh.teki@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, davem@davemloft.net,
        linux-ide <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are robocoping small files you will hit other limits.

Best I have seen with small files is around 30 files/second, and that
involves multiple copies going on.   Remember with a small files there
are several reads and writes that need to be done to complete a create
of a small file and each of these take time.    30 files/second ~ 30ms
per file, not that bad considering that on a real spinning disk a
single read/write op is 5-10ms, and creating the file entry, copying
data and closing the file takes several operations (at least create
file entry, write small amount of data, update file entry
date/time/info).     If the write in the middle is not a significant
amount of data, the 2 extra ops are what hurts.

On Fri, Nov 14, 2014 at 6:55 AM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
> Hi,
>
> I'm doing a performance testing on my bench ARM box.
>
> 1. dd test: I have validate the read and write by mounting /dev/sda1
> with ext4 filesystem,
>     able to get the good performance numbers where read is high
> compared to write
>
> 2.  robocopy test:
>      - mkfs.ext4 /dev/sda1
>      - mount /dev/sda1 /media/disk
>      - << configured samba >>
>      - Mapped the /media/disk on windows
>      - login on the mapped driver in windows
>      - did a robocopy test, where write got 84MBps and read 14MBps
>
> read performance is too slow when compared to write in robocopy case.
> Can anyone help me out, how to debug this further.
>
> thanks!
> --
> Jagan.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
