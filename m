Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3HERIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab3HERIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:08:07 -0400
Message-ID: <51FFDC4E.20001@redhat.com>
Date: Mon, 05 Aug 2013 19:09:34 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com> <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com> <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic> <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic>
In-Reply-To: <20130805164731.GG31845@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 18:47, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 06:41:20PM +0200, Laszlo Ersek wrote:
>> I didn't realize the timestamps survive kexec. (As far as I remember
>> the kernels I played with kexec on didn't have the automatic
>> timestamps yet in dmesg, but I might have messed up just as well...)
> 
> No, no, no, kexec is not involved at all.

I understand. I just explained why I could not derive that fact from the
timestamps. You said,

> No, kexec is not even involved yet. If you look at the timestamps,
> there's 0.005 seconds between the two dumps during the *same* kernel
> booting on the machine, baremetal, straight from grub.

There are four memmap dumps:

(1) first boot, initial dump,
(2) first boot, dump when entering virtual mode,
(3) kexec boot, initial dump,
(4) kexec boot, dump when entering virtual mode.

I was aware that we were discussing a problem either between (1) and
(2), *or* between (3) and (4); I just didn't know inside "which pair".

I misunderstood your reply and thought that you were implying the
(1)+(2) pair by the low absolute timestamps. I assumed that (3)+(4)
would print low timestamps as well (due to the time offset starting from
zero in the kexec kernel too) and took your message as a correction to
that idea. But, you didn't say anything about the magnitude of the
timestamps, only about the differences between them.

Sorry for the noise, it's clear now that we're looking at (1)->(2).

Thanks
Laszlo
