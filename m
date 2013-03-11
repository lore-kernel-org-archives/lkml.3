Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3CKSuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:50:35 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:34897 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3CKSue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <513E2695.3080707@zytor.com>
References: <513D52BA.3070206@redhat.com>
	<1362977817-23297-1-git-send-email-yinghai@kernel.org>
	<20130311144853.GB8482@redhat.com>
	<20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com>
	<513E2695.3080707@zytor.com>
Date: Mon, 11 Mar 2013 11:50:33 -0700
X-Google-Sender-Auth: jezbDfrwgy8NanxPSDZJxgQXHmc
Message-ID: <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/11/2013 11:26 AM, Vivek Goyal wrote:
>>>
>> Hi Yinghai,
>>
>> In mutt your patches are showing as attachment instead of inline. Mutt
>> thinks attachment is of type "application/octet-stream". Not sure if
>> this is configuration issue on my part or something is going on your
>> end.
>>
>> I have few more concerns.
>>
>> - Are we able to reserve 512MB memory now below 896MB. I remember so
>>   far it was broken.
>>
>
> What is the purpose of reserving that kind of memory below 896 MB?  If
> you have a 32-bit system, it will likely be useless since you are
> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
> a magic value in any way...?

We did not touch 32 bit system.

Do you mean that we should
For 64bit, we should try under 4G, and then try MAXMEM
instead of try under 896M, then 4G, and MAXMEM?

Try 896M at first, we will let user to avoid updating their kexec-tools.

Thanks

Yinghai
