Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbbAICL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:11:57 -0500
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:52080 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbbAICL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:11:56 -0500
Message-ID: <54AF38EA.6090005@nexus-software.ie>
Date: Fri, 09 Jan 2015 02:11:54 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific
 setup
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <1419873783-5161-3-git-send-email-pure.logic@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B7326E3282@PGSMSX105.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B7326E3282@PGSMSX105.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 01:00, Ong, Boon Leong wrote:

>> +static void __init
>> +intel_galileo_imr_sanity(unsigned long base, unsigned long size) {
>> +	/* Test zero zero */
>> +	if (imr_add(0, 0, 0, 0, true) == 0)
>> +		pr_err(SANITY "zero sized IMR @ 0x00000000\n");
>
> A side-discussion on imr_add():
> I would think that we should allow 1KiB IMR setting. Current imr_add() logic
> is prohibiting it.

Hi Boon Leong. Ermm, it does allow 1 KiB IMR regions. The following code 
works on the unmodifed V1 driver.

/* Test 1 KiB works */
idx = imr_add(0, IMR_ALIGN, IMR_READ_ACCESS_ALL,
               IMR_WRITE_ACCESS_ALL,false);
if (idx < 0)
	pr_err(SANITY "Couldn't add an IMR @ 0x%04x bytes\n", IMR_ALIGN);

Note IMR_ALIGN is 0x400

I'll add that test to the set of sanity tests in V2 just to put your 
mind at ease though.

 > So, the 'size' input should be at least 1KiB and imr_add()
 > internal logic will adjust 'hi' by -1KiB. Please consider ..

Hmm.

Actually I had a response all typed out for you why I didn't want an API 
to presume to modify the size of my input from the user's POV but, 
thinking about it twice - I agree with you.

V2 will subtract IMR_ALIGN (0x400) bytes from the size.

It's stupid to have to subtract IMR_ALIGN bytes on the input - and 
assumes the user of the API understands how the hardware works - but, of 
course the point of an API is so that the user of it doesn't *have* to 
understand that.

Good call.

--
BOD
