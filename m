Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3DAVRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:17:07 -0400
Received: from smtp1.nethome.no ([92.62.33.11]:52497 "EHLO smtp1.nethome.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab3DAVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:17:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Apr 2013 23:17:00 +0200
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
Message-ID: <733a6b303b7e9a3c4fb396acad9d9c5c@gentoo.se>
User-Agent: Roundcube Webmail/0.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-03-28 14:12 skrev Peter.Huewe@infineon.com:
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

I've enabled it in BIOS now, and the output seems to be a bit 
different. Not too uplifting though...

root@zepto:/home/peter# dmesg | grep tpm
[   14.631662] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[   14.748276] tpm_tis 00:08: Adjusting TPM timeout parameters.
[   34.908128] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  125.992108] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[  212.908502] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
root@zepto:/home/peter# tpm_version
Tspi_Context_Connect failed: 0x00003011 - layer=tsp, code=0011 (17), 
Communication failure
root@zepto:/home/peter# tcsd -f
TCSD TDDL ioctl: (25) Inappropriate ioctl for device
TCSD TDDL Falling back to Read/Write device support.
TCSD TDDL ERROR: write to device /dev/tpm0 failed: Timer expired
TCSD TCS ERROR: TCS GetCapability failed with result = 0x1087

/Peter A
