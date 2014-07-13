Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaGMXRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 19:17:51 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:63925 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaGMXRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 19:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAH2r5muwjdPopeGCOi8a7OxAm=8cFsFKsEBywz5N1NQWotni6Q@mail.gmail.com>
References: <CAH2r5muwjdPopeGCOi8a7OxAm=8cFsFKsEBywz5N1NQWotni6Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 13 Jul 2014 18:17:25 -0500
Message-ID: <CAH2r5mtz0NJETUimTPrtdzfN23Wx7G82xGFa9NT_pLM-mCPezg@mail.gmail.com>
Subject: Re: Additional performance data on Pavel's smb3 multi credit patch series
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repeating these large file copy tests with SMB3 mounts with Pavel's
patches and trying larger wsize and rsize of 4MB (and later 5MB) did
not seem to help performance much (over his default with the new
patchset, 1MB).   I want to repeat these with real network adapters
(rather than in vmware or kvm) to compare though (to see if the larger
wsize and rsize help)

On Sun, Jul 13, 2014 at 2:23 PM, Steve French <smfrench@gmail.com> wrote:
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



-- 
Thanks,

Steve
