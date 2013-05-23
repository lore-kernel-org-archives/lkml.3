Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3EWHpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:45:34 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45046 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3EWHpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:45:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130523033911.GA9411@redhat.com>
References: <20130521230332.GC12713@redhat.com>
	<519D1668.6000601@zytor.com>
	<20130522200012.GA15456@redhat.com>
	<ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
	<20130523033911.GA9411@redhat.com>
Date: Thu, 23 May 2013 15:45:32 +0800
Message-ID: <CACVXFVP3stgc2JKc31_yjPuokTbqcSrW_FWDvHrHK+NA-xu-yg@mail.gmail.com>
Subject: Re: microcode loading got really slow.
From: Ming Lei <tom.leiming@gmail.com>
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:39 AM, Dave Jones <davej@redhat.com> wrote:
>  > On 05/21/2013 04:03 PM, Dave Jones wrote:
>  >
>  > [   72.318133] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x6
>  > [  132.446449] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x6
>  > [  192.573101] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x6
>  > [  252.702055] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>  >
>  > For some reason the events for udev seem to be getting delayed 60s
>  > for each core.
>
> Screwed up my .config, and had CONFIG_FW_LOADER_USER_HELPER inadvertantly set
> Odd though that it causes that 60 second delay, given that it's supposedly a
> 'fallback' when the direct loading fails.

udevd has the ugly problem previously at some situations(for example,
request_firmware called in probe(), and that is why direct loading is
introduced),
but not sure why the direct loading is failed first.

Could you enable 'CONFIG_DEBUG_DRIVER' and post 'dmesg' out?
And better to check where the affected firmware(microcode) is in your
distribution.

>
> It seems I don't actually need to set that option, so I'm not bothered
> if there's an actual bug here or not, but the behaviour seems odd.

If the option isn't set, the firmware will be lost for the requested CPU, :-)

Thanks,
-- 
Ming Lei
