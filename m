Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaIDV3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:29:31 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52877 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaIDV33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:29:29 -0400
Date: Thu, 4 Sep 2014 22:29:25 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Message-ID: <20140904212925.GL3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5408D299.5000300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:
> 
> I am fine with this patch, but at the same time I do want to note that
> there is an alternative to double-buffer the patch and/or (if that
> applies to the buggy BIOS) round up the size of the target buffer.

I'm not sure that rounding up the size of the target buffer will
workaround this issue correctly.

As far as I know, the only thing that Mantas tried was rounding up the
size of the source file, by padding it.

Laszlo, is there anything we can do in the kernel to avoid the EDK2 bug
you fixed here,

  https://github.com/tianocore/edk2/commit/4e39b75e

such as lying about the number of bytes we're trying to read or
allocating a bigger target buffer than we actually need?

Assuming of course, that the bug that Laszlo fixed and the bug that
Mantas is hitting are one and the same.

-- 
Matt Fleming, Intel Open Source Technology Center
