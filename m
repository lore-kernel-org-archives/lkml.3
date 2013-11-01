Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3KAPrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:47:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44997 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3KAPrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:47:48 -0400
MIME-Version: 1.0
In-Reply-To: <20131101142115.GK17455@8bytes.org>
References: <CA+MoWDqoBxuFhBsf_rVBT1C8=mwj02hXgPfuWnjY4yeVa-84cA@mail.gmail.com>
	<20131101130702.GA3348@8bytes.org>
	<CA+MoWDoDTFarOLUHgNmUFksRvV-R+7jufUwLbsS8ecaO+_m2kQ@mail.gmail.com>
	<20131101142115.GK17455@8bytes.org>
Date: Fri, 1 Nov 2013 16:47:47 +0100
Message-ID: <CA+MoWDq4jYCD9zGaPA_Z4AL3Rj6hu4-rMEofn=8uWEGP6Tdruw@mail.gmail.com>
Subject: Re: VT-d and x2apic: broken resume after suspend to ram
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 3:21 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Nov 01, 2013 at 02:21:07PM +0100, Peter Senna Tschudin wrote:
>> On Fri, Nov 1, 2013 at 2:07 PM, Joerg Roedel <joro@8bytes.org> wrote:
>> > Which kernels have you tried? Does it happen with all of them or is
>> > there a kernel-version where this started?
>>
>> I'm using 3.11.6-200.fc19.x86_64. I always had VT-d enabled, and
>> suspend / resume never worked on Linux. I did not know that disabling
>> VT-d could be a workaround to the resume issue until yesterday.
>>
>> Does this have anything in common to:
>> https://bugzilla.redhat.com/show_bug.cgi?id=752613
>
> This is probably not related. As far as I can see this issue was about
> boot problem with discrete graphics while your problem is related to
> suspend/resume.
>
> The next thing I would try on your machine is to get some kernel debug
> messages from resume. This might be hard to get, since your notebook
> has probably no serial port. But you can try to boot with
> no_console_suspend on the kernel cmdline and see if it gives you any
> output on resume.
Only serial ports over USB:
usb 2-1.3.2: pl2303 converter now attached to ttyUSB0

The issue with no_console_suspend is that the monitor is powered off
on suspend and never resume after that. The external monitor enters in
power save mode during suspend and also never resume. Do you know if
replacing my wifi/bt card by this:

http://www.startech.com/Cards-Adapters/Serial-Cards-Adapters/2-Port-RS232-Mini-PCI-Express-Serial-Card-16950-UART~MPEX2S952

would enable to use the serial console for seeing kernel debug messages?

>
> Maybe some of the VT-d guys can take a look too?
>
>
>         Joerg
>



-- 
Peter
