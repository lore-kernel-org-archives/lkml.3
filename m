Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3EWKSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:18:54 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35002 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab3EWKSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <s5hwqqqvw59.wl%tiwai@suse.de>
References: <20130521230332.GC12713@redhat.com>
	<519D1668.6000601@zytor.com>
	<20130522200012.GA15456@redhat.com>
	<ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
	<20130523033911.GA9411@redhat.com>
	<CACVXFVP3stgc2JKc31_yjPuokTbqcSrW_FWDvHrHK+NA-xu-yg@mail.gmail.com>
	<s5h7giq86hr.wl%tiwai@suse.de>
	<s5hwqqqvw59.wl%tiwai@suse.de>
Date: Thu, 23 May 2013 15:48:52 +0530
Message-ID: <CAK7N6vqSfPqu6fig8dOEf-Tu0hRsgxLQA7MGupawn-XZHB6MiQ@mail.gmail.com>
Subject: Re: microcode loading got really slow.
From: anish singh <anish198519851985@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>, Dave Jones <davej@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 3:46 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 23 May 2013 10:06:56 +0200,
> Takashi Iwai wrote:
>>
>> At Thu, 23 May 2013 15:45:32 +0800,
>> Ming Lei wrote:
>> >
>> > On Thu, May 23, 2013 at 11:39 AM, Dave Jones <davej@redhat.com> wrote:
>> > >  > On 05/21/2013 04:03 PM, Dave Jones wrote:
>> > >  >
>> > >  > [   72.318133] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x6
>> > >  > [  132.446449] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x6
>> > >  > [  192.573101] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x6
>> > >  > [  252.702055] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> > >  >
>> > >  > For some reason the events for udev seem to be getting delayed 60s
>> > >  > for each core.
>> > >
>> > > Screwed up my .config, and had CONFIG_FW_LOADER_USER_HELPER inadvertantly set
>> > > Odd though that it causes that 60 second delay, given that it's supposedly a
>> > > 'fallback' when the direct loading fails.
>> >
>> > udevd has the ugly problem previously at some situations(for example,
>> > request_firmware called in probe(), and that is why direct loading is
>> > introduced),
>> > but not sure why the direct loading is failed first.
>>
>> The microcode update is optional, so it's no error even if the
>> microcode firmwares are not found.
>>
>> But yes, this seems happening during the module probing.  The lines
>> "microcde: CPU..." show before "microcode: Microcode Update
>> Driver...", which means the f/w loading has been done before finishing
>> the module load.
>>
>> I thought (or hoped) this mess (60s stalls) was fixed in the recent
>> udev, but apparently not...?
>
> Thinking on this again, if the user-space continues to be broken in
> that point, we should provide request_firmware() variant without udev,
> e.g. request_firmware_direct(), and use it in known places like this?
Is it not already there?I was thinking that some time back this support
was added.
>
>
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
