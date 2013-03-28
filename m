Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3C1O7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:59:11 -0400
Received: from smtp3.nethome.no ([92.62.33.13]:45229 "EHLO smtp.nethome.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab3C1O7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:59:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Mar 2013 15:58:58 +0100
From: peterasplund@gentoo.se
To: <Peter.Huewe@infineon.com>
Cc: <aaron.lu@intel.com>, <mail@srajiv.net>,
        <tpmdd-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <key@linux.vnet.ibm.com>
Subject: RE: [tpmdd-devel] =?UTF-8?Q?tpm=5Ftis=20driver=20failed=20to=20su?=
 =?UTF-8?Q?spend=2C=20error=20-=36=32?=
In-Reply-To: <74A44E99E3274B4CB570415926B37D4414B14E@MUCSE501.eu.infineon.com>
References: <20130319023440.GA12425@aaronlu.sh.intel.com>
 <CAA25o9RJJ5Rkti9_fTJz2ieaHvrtSp5mE_2LTW_t16_cf_TNcg@mail.gmail.com>
 <ed364e68730267510d49b2bdc38679a0@gentoo.se>
 <CAEQAOwpmnLXBCJQTf_xU-oSKvAtmpQjHWwMYDm_QOsP+1Kd_aQ@mail.gmail.com>
 <CAEQAOwqWL=WekQqg5WY8TGxzB3x9nB9MVj_UTAVK0ro7TqB2WQ@mail.gmail.com>
 <51540408.3000702@intel.com>
 <74A44E99E3274B4CB570415926B37D4414B14E@MUCSE501.eu.infineon.com>
Message-ID: <305f547e719f45dccebaa8a5056dcfb6@gentoo.se>
User-Agent: Roundcube Webmail/0.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter!

Thank you for your help! I'm going away for the Easter holiday, and 
will be back on Monday/Tuesday. I will try to supply the information you 
need at that time, since I won't be bringing my laptop with me.

BR
Peter A

2013-03-28 14:12 skrev Peter.Huewe@infineon.com:
> Hi Aaron, Rajob, PeterA and everybody else,
>
> (sorry for the late reply)
>
>>On 03/27/2013 11:22 PM, Rajiv Andrade wrote:
>>> Sorry for the delay. Can you send us the dmesg output after setting
>>> loglevel=7 at boot time? Additionally, can you send us the TPM 
>>> manufacturer model/version
>
>>>> On Thu, Mar 21, 2013 at 10:17 AM, <peterasplund@gentoo.se> wrote:
>>>>>
>>>>> Hi! Sadly, I have to say that I'm totally oblivious to 
>>>>> power-related
>>>>> stuff both in software and hardware, so I have no idea what you 
>>>>> are
>>>>> asking or proposing.. :
>
> According to the BootDmesg.txt it's an Infineon TPM
> [    0.293936] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102
> PNP0c31 (active)
> [   12.413651] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
>
>
>
>
> @PeterA:
> Can you perhaps try find out the exact tpm version?
> 1) Install trousers and tpm_tools (emerge app-crypt/trousers
> app-crypt/tpm-tools)
> 2) Kill the tcsd and run it in the foreground
> # pkill -9 tcsd
> # tcsd -f
> (if it says up and running you can send it to background)
> 3) Run
> #tpm_version and post the output.
>
>
>
> Also the flags etc would perhaps be handy, they can be retrieved via
> sysfs - on you machine it _should_ be
> # cat /sys/devices/pnp0/00:0a/*
> and also post the output.
>
>
> What also might be worth a look - in your bugzilla it states:
> [ 0.225891] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 
> (active)
> [ 9.150673] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
> [ 9.292148] tpm_tis 00:0a: Adjusting TPM timeout parameters.
> [ 10.084067] tpm_tis 00:0a: A TPM error (7) occurred attempting to 
> read a pcr
> value
> [ 10.084077] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
>
>
> Can you perhaps try to enable your TPM in the BIOS? It's quite often
> hidden under "embedded security device" or "system security".
> Quite often you have to have a bios password set to access these 
> settings.
> If your system does not have bios support for TPMs, please tell me so
> and I'll try to help you out.
>
> Thanks,
> PeterH
