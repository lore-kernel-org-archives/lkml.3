Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaG3DZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:25:45 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:46556 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaG3DZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:25:43 -0400
MIME-Version: 1.0
In-Reply-To: <53D82623.4080903@redhat.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
	<20140729222932.GA17481@pd.tnic>
	<53D82118.6090202@redhat.com>
	<20140729223603.GC17241@pd.tnic>
	<53D82623.4080903@redhat.com>
Date: Tue, 29 Jul 2014 20:25:41 -0700
Message-ID: <CAKbGBLi-6koxxQUDsn+KyO47nfCbOwFSnPgbDZGZ1Bnt=c5qKA@mail.gmail.com>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
From: Steven Noonan <steven@uplinklabs.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 3:54 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 07/29/2014 06:36 PM, Borislav Petkov wrote:
>> On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
>>> and it was best to keep the code simple with a KiB.
>>
>> You're missing the point - the output doesn't get simple with KiB. Read
>> the example I just gave you!
>>
>> (13893632kiB) is actively *not* helping when one looks at it!
>
> I did get your point and I'm (politely) disagreeing with it.  Your case ONLY
> works if the number is _exactly_ 13GB.  What if it is 13.5?  Then we're still
> rounding off and reporting 14GB.  Which, if this code is meant for debug, makes
> no sense to me.  Why round it off?
>

I think if it was being represented in procfs or sysfs, we'd need to
be extremely specific to make it machine-readable, but for a
human-readable printk, it makes sense to me to print it in the smaller
unit size until the value is in tens of the next higher unit size
(e.g. print in KiB until 10+MiB, print in MiB until 10+GiB).
