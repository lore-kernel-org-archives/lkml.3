Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3LNWVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 17:21:38 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:33049 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3LNWVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 17:21:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131214214409.GA26816@kroah.com>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
	<1386973529-4884-2-git-send-email-john.stultz@linaro.org>
	<20131214165257.GA25393@kroah.com>
	<CAMbhsRRrE7m_aQRS-BB-4Jr8m0WaSADjek=tPfTu2uMoZTaXxA@mail.gmail.com>
	<20131214214409.GA26816@kroah.com>
Date: Sat, 14 Dec 2013 14:21:36 -0800
X-Google-Sender-Auth: 2GSHUNNRWO2IejlhF8cLp-g6El4
Message-ID: <CAMbhsRSFcjo0YfTuWc9triYfXNXDMK=Q=Jsuh6dPe4Tb6qrJLA@mail.gmail.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 1:44 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Dec 14, 2013 at 01:10:38PM -0800, Colin Cross wrote:
>> On Sat, Dec 14, 2013 at 8:52 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Fri, Dec 13, 2013 at 02:23:35PM -0800, John Stultz wrote:
>> >> +     idev->debug_root = debugfs_create_dir("ion", NULL);
>> >> +     if (IS_ERR_OR_NULL(idev->debug_root))
>> >> +             pr_err("ion: failed to create debug files.\n");
>> >
>> > There's no need to check for this at all, you just printed out an error
>> > message if CONFIG_DEBUGFS is not enabled, which isn't all that nice.
>> >
>> > Something to clean up later, no big deal now.
>>
>> Patch 75/115 (ion: remove IS_ERR_OR_NULL) replaces this chunk with:
>>         idev->debug_root = debugfs_create_dir("ion", NULL);
>>         if (!idev->debug_root)
>>                 pr_err("ion: failed to create debug files.\n");
>> which won't print an error if debugfs is disabled.
>
> If debugfs is disabled, debugfs_create_dir() returns ERR_PTR(-ENODEV).

ERR_PTR(-ENODEV) is not NULL, so this won't print an error.  I thought
that was the point of returning ERR_PTR when disabled and NULL when
enabled.

> So are you sure you tested this?  :)

I have not tested this, but it seems correct to me.
