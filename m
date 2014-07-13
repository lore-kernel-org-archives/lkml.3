Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaGMXVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 19:21:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36208 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaGMXVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 19:21:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAH2r5muwjdPopeGCOi8a7OxAm=8cFsFKsEBywz5N1NQWotni6Q@mail.gmail.com>
References: <CAH2r5muwjdPopeGCOi8a7OxAm=8cFsFKsEBywz5N1NQWotni6Q@mail.gmail.com>
Date: Sun, 13 Jul 2014 16:21:40 -0700
Message-ID: <CAN05THTTXU_=8rboaJfePmNDU6rNK9suMPTyXrvvnmd9CQF3Rw@mail.gmail.com>
Subject: Re: Additional performance data on Pavel's smb3 multi credit patch series
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impressive!

On Sun, Jul 13, 2014 at 12:23 PM, Steve French <smfrench@gmail.com> wrote:
> Performance of Pavel's multicredit i/o SMB3 patches continues to look
> good.  Additional informal performance results below comparing cifs
> mounts with smb3 mounts (vers=3.0) with and without Pavel's patch set.
> I plan to do additional testing with large rsize/wsize (default with
> Pavel's code is 1MB).
>
> 3.16-rc4 (Ubuntu) on client.  Server is Windows 8.1.  Both VMs on same
> host (host disk is fairly fast SSD).
>
> Copy to server performance increased about 20% percent
> dd if=/dev/zero of=/mnt/targetfile bs=80M count=25
> got similar results with or without conv=fdatasync
>
> 1st run copying to empty directory, 2nd run copying over targetfile,
> (pattern repeated multiple times) averaging results
>
> New code (with Pavel's patches)
> ---------------------------------------------
> CIFS 167MB/s
> SMB3 200MB/s
>
> Existing code (without his patches)
> ------------------------------------------------
> SMB3 166MB/s
> CIFS 164.5MB/s
>
> For large file reading SMB3 performance with Pavel's patches increased
> 76% over existing SMB3 code
> dd of=/dev/null if=/mnt/targetfile bs=80M count=25
> (mounting and unmounting between attempts to avoid caching effects on
> the client)
>
> New code (with Pavel's patches)
> ---------------------------------------------
> CIFS 114MB/s
> SMB3 216MB/s
>
> Existing code (without his patches)
> ------------------------------------------------
> SMB3 123MB/s
> CIFS 110MB/s
>
> --
> Thanks,
>
> Steve
