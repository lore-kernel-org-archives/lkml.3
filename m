Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935642Ab3DIX66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:58:58 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:60083 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765410Ab3DIX64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <1365501657-4213-7-git-send-email-serban.constantinescu@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-7-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 9 Apr 2013 16:58:56 -0700
Message-ID: <CAMP5Xgew5_F2De2+7Ny39iww2Un6hC8B3aYNV7CEawovkFg1Og@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] staging: android: binder: fix alignment issues
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> The Android userspace aligns the data written to the binder buffers to
> 4bytes. Thus for 32bit platforms or 64bit platforms running an 32bit
> Android userspace we can have a buffer looking like this:
>
> platform    buffer(binder_cmd   pointer)      size
> 32/32                 32b         32b          8B
> 64/32                 32b         64b          12B
> 64/64                 32b         64b          12B
>
> Thus the kernel needs to check that the buffer size is aligned to 4bytes
> not to (void *) that will be 8bytes on 64bit machines.
>
> The change does not affect existing 32bit ABI.
>

Do we not want the pointers to be 8 byte aligned on 64bit platforms?

--
Arve Hjønnevåg
