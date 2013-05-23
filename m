Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab3EWKpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:45:35 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49100 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab3EWKp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <s5hr4gyvv7r.wl%tiwai@suse.de>
References: <20130521230332.GC12713@redhat.com>
	<519D1668.6000601@zytor.com>
	<20130522200012.GA15456@redhat.com>
	<ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
	<20130523033911.GA9411@redhat.com>
	<CACVXFVP3stgc2JKc31_yjPuokTbqcSrW_FWDvHrHK+NA-xu-yg@mail.gmail.com>
	<s5h7giq86hr.wl%tiwai@suse.de>
	<s5hwqqqvw59.wl%tiwai@suse.de>
	<CACVXFVMsTjSqvyVkZEPfWgHDUJ_mqwqWy=vydCsTvv7TS-EKiQ@mail.gmail.com>
	<s5hr4gyvv7r.wl%tiwai@suse.de>
Date: Thu, 23 May 2013 18:45:29 +0800
Message-ID: <CACVXFVNO9FeCaJ_YFbvPMUHOBjneLqqW+ucYprZb7884Eth-DA@mail.gmail.com>
Subject: Re: microcode loading got really slow.
From: Ming Lei <tom.leiming@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 6:36 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
> No, f/w loader always fall back to user mode helper, as long as its
> support is built in.  And doing that for microcode driver in that code
> path isn't only superfluous but also broken due to request_firmware
> call in module init.

Firstly, it is not good to do this since some distributions doesn't support
direct loading and doesn't have udevd(such as, android).

Secondly, returning failure from request_firmware_direct() doesn't mean
the firmware doesn't exist since distribution may put the firmware other where.

Anyway, this example is very specific(no firmware can be accepted), and
request_firmware_nowait() should be OK for the situation.

>
>> wrt. this problem, I think we
>> need to know why the direct loading is failed.
>
> The reason is obvious: the requested f/w file doesn't exist.
> And it's fine, because the microcode update is an optional operation.
> If no f/w file is found, it's not handled as an error.  It just means
> that no need to update, continuing to work.

OK, as said above, the example is very specific, and might be
workarounded by request_firmware_nowait().


Thanks,
-- 
Ming Lei
