Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3IZXSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:18:49 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:55076
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab3IZXSr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:18:47 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1155h)
X-WSS-ID: 0MTR9U1-07-SFF-02
X-M-MSG: 
Message-ID: <5244C0C7.80109@amd.com>
Date: Thu, 26 Sep 2013 18:18:31 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: <jacob.w.shin@gmail.com>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86, microcode, AMD: Fix patch level reporting for family15h
References: <1380232472-2589-1-git-send-email-suravee.suthikulpanit@amd.com> <20130926221322.GC10123@pd.tnic> <20130926230623.GA1764@alberich>
In-Reply-To: <20130926230623.GA1764@alberich>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/2013 6:06 PM, Andreas Herrmann wrote:
> On Fri, Sep 27, 2013 at 12:13:22AM +0200, Borislav Petkov wrote:
>> On Thu, Sep 26, 2013 at 04:54:32PM -0500, suravee.suthikulpanit@amd.com wrote:
>>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>>
>>> On AMD family15h, applying microcode patch on the a core (core0)
>>> would also affect the other core (core1) in the same compute unit.
>>> The driver would skip applying the patch on core1, but it still
>>> need to update kernel structures to reflect the proper patch level.
>>>
>>> The current logic is not updating the struct ucode_cpu_info.cpu_sig.rev
>>> of the skipped core. This causes the /sys/devices/system/cpu/cpu1/microcode/version
>>> to report incorrect patch level as shown below:
>>>
>>> [   10.708841] microcode: CPU0: new patch_level=0x0600063d
>>> [   10.714256] microcode: CPU1: patch_level=0x06000626
>>> [   10.719345] microcode: CPU2: patch_level=0x06000626
>>> [   10.748095] microcode: CPU2: new patch_level=0x0600063d
>>> [   10.753365] microcode: CPU3: patch_level=0x06000626
>>> [   10.758264] microcode: CPU4: patch_level=0x06000626
>>> [   10.786999] microcode: CPU4: new patch_level=0x0600063d
>> Actually, this is collect_cpu_info_amd()'s normal operation and shows
>> that there's no need to apply a microcode patch on the odd core since
>> the even core's ucode has been updated.
> Hmm, I think Boris is right, above messages are just logging what
> happened during µcode update. I think the patch_level in "CPU1:
> patch_level=0x06000626" is based on c->microcode which is updated
> shortly after this message was printed.
>
> I assume with your patch, above message won't look different but just
> the contents in /sys/devices/system/cpu/cpu1/microcode/version will
> show the correct version, right?
>
>
> Andreas
>
Yes, the message in dmesg is still showing the same. Only the sysfs... 
version is now fixed.

Suravee

