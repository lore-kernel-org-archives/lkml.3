Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbaH0RNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:13:25 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:49096 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaH0RNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:13:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140827105901.GC28116@console-pimps.org>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<20140827105901.GC28116@console-pimps.org>
Date: Wed, 27 Aug 2014 10:13:22 -0700
X-Google-Sender-Auth: He537Cm4H5wuUJ2v6QEoPy1ee7A
Message-ID: <CAE9FiQWrPtEe3tkJjgOzyJJPPzX=AtMYgR4c91pDHL3q3ZLLKQ@mail.gmail.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Harald Hoyer <harald@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 3:59 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 26 Aug, at 02:45:44PM, Yinghai Lu wrote:
> The reason I suggested introducing some kind of kernel parameter to
> allow loading above 4G is because if Mantas loads a 5GB initrd with your
> patch, his machine is still going to hang, with no indication of why it
> hung.
>
> At least with a kernel paramter, by default we can try to load under 4G,
> and if that fails because the file is too big we can print something
> along the lines of,
>
>   "initramfs file too large: try booting with efi=file-max"
>
> No, it's not ideal, but I think it's a worthwhile compromise because
> you're only going to run into this issue when loading a huge initramfs
> with the EFI boot stub.

I would like to avoid adding more kernel parameter.

How about adding more info print out like:
  "Try to load initrd file to higher address..."

Thanks

Yinghai
