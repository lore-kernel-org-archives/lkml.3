Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbbAFRXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:23:17 -0500
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:50170 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbbAFRXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:23:15 -0500
Message-ID: <54AC19FE.3040906@nexus-software.ie>
Date: Tue, 06 Jan 2015 17:23:10 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: Add IMR support to Quark/Galileo
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <20150106055959.GA59754@vmdeb7> <54ABE989.8060701@nexus-software.ie> <20150106164805.GA27956@vmdeb7>
In-Reply-To: <20150106164805.GA27956@vmdeb7>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 16:48, Darren Hart wrote:
>> Correct. Firmware locks the IMRs around ACPI runtime data data.
>>
>> In the patch here, we cycle though every unlocked IMR and zap it - which
>> will include tear-down of the IMRs placed around the compressed kernel image
>> and boot params data structure. Firmware puts those IMRs in place to ensure
>> no invalid DMA, SMM access to the compressed kernel image during boot can
>> take place.
>
> Thanks Bryan, this clears these questions up for me.
>
> Are we confident that the tear-down of the IMRs around the compressed kernel
> image happens early enough and deterministically, such that there is no race
> condition in which a driver could get DMA into this memory?

Yes confident :)

Tested by baking IMR-platform code + MMC into the kernel and mounting 
the rootfs on Galileo from MMC.

Also tested the reverse case. Attempting to mount an SD kills every 
version of the tip-of-tree I've used with an IMR reset.

Just to be really sure, it's also been tested with the initial 0.7.5 and 
0.8.0 release which didn't have DMI strings to identify the board.

So - with this change in place tip-of-tree should work for everybody on 
Galileo Gen1/Gen2.

It should get the Galileo Debian people out of the business of needing 
to have a separate kernel to boot - though obvious more enabling work 
needs to happen in SoC space still.

http://sourceforge.net/projects/galileodebian/

Also I'm hoping - though I don't have the exact details of this - that 
the crash/non-boot situation for CentOs on Galileo may be as a result of 
IMRs, so hopefully will be of use there too.




