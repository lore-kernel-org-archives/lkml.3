Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3C1NWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:22:39 -0400
Received: from smtp2.infineon.com ([217.10.52.18]:40234 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab3C1NWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:22:38 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 09:22:37 EDT
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <aaron.lu@intel.com>, <mail@srajiv.net>, <peterasplund@gentoo.se>
CC: <tpmdd-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <key@linux.vnet.ibm.com>
Subject: RE: [tpmdd-devel] tpm_tis driver failed to suspend, error -62
Thread-Topic: [tpmdd-devel] tpm_tis driver failed to suspend, error -62
Thread-Index: AQHOKwNWW9kxaOIYfE+hF1ecEL/pS5i6u3IAgABU5GA=
Date: Thu, 28 Mar 2013 13:12:54 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D4414B14E@MUCSE501.eu.infineon.com>
References: <20130319023440.GA12425@aaronlu.sh.intel.com>
	<CAA25o9RJJ5Rkti9_fTJz2ieaHvrtSp5mE_2LTW_t16_cf_TNcg@mail.gmail.com>
	<ed364e68730267510d49b2bdc38679a0@gentoo.se>
	<CAEQAOwpmnLXBCJQTf_xU-oSKvAtmpQjHWwMYDm_QOsP+1Kd_aQ@mail.gmail.com>
	<CAEQAOwqWL=WekQqg5WY8TGxzB3x9nB9MVj_UTAVK0ro7TqB2WQ@mail.gmail.com>
 <51540408.3000702@intel.com>
In-Reply-To: <51540408.3000702@intel.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron, Rajob, PeterA and everybody else,

(sorry for the late reply)

>On 03/27/2013 11:22 PM, Rajiv Andrade wrote:
>> Sorry for the delay. Can you send us the dmesg output after setting
>> loglevel=7 at boot time? Additionally, can you send us the TPM manufacturer model/version

>>> On Thu, Mar 21, 2013 at 10:17 AM, <peterasplund@gentoo.se> wrote:
>>>>
>>>> Hi! Sadly, I have to say that I'm totally oblivious to power-related 
>>>> stuff both in software and hardware, so I have no idea what you are 
>>>> asking or proposing.. :

According to the BootDmesg.txt it's an Infineon TPM
[    0.293936] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[   12.413651] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)




@PeterA: 
Can you perhaps try find out the exact tpm version?
1) Install trousers and tpm_tools (emerge app-crypt/trousers app-crypt/tpm-tools)
2) Kill the tcsd and run it in the foreground
# pkill -9 tcsd
# tcsd -f
(if it says up and running you can send it to background)
3) Run 
#tpm_version and post the output.



Also the flags etc would perhaps be handy, they can be retrieved via sysfs - on you machine it _should_ be
# cat /sys/devices/pnp0/00:0a/*
and also post the output.


What also might be worth a look - in your bugzilla it states:
[ 0.225891] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[ 9.150673] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[ 9.292148] tpm_tis 00:0a: Adjusting TPM timeout parameters.
[ 10.084067] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr
value
[ 10.084077] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)


Can you perhaps try to enable your TPM in the BIOS? It's quite often hidden under "embedded security device" or "system security".
Quite often you have to have a bios password set to access these settings.
If your system does not have bios support for TPMs, please tell me so and I'll try to help you out.

Thanks,
PeterH
