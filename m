Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbbAKBxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 20:53:38 -0500
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:57674 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbbAKBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 20:53:37 -0500
Message-ID: <54B1D79E.3070602@nexus-software.ie>
Date: Sun, 11 Jan 2015 01:53:34 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific
 setup
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <1419873783-5161-3-git-send-email-pure.logic@nexus-software.ie> <20150109044613.GB9311@vmdeb7> <54AFB8D7.6020306@nexus-software.ie> <20150110065409.GA104814@vmdeb7>
In-Reply-To: <20150110065409.GA104814@vmdeb7>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm wondering if there is a need for this to be a platform driver at
> all. Could we, instead, tear down any unlocked IMRs at boot as part of the IMR
> driver itself, as well as lock the kernel .text. Firmware has the option of
> making an IMR mandatory by locking it. If it isn't locked, what use is it to the
> OS without a lot more context? Any sort of policy enforced with IMRs is a
> user-space decision, so clearing out the unlocked ones and then handing off to
> user-space seems like a sane default mode to me.
>
> I discussed this with Boon Leong this afternoon and we couldn't come up with a
> justification for a platform-specific driver to do what this does.

I think there's no technical reason impeding what you've just suggested 
in the IMR init and I'm happy to move the code in there since basically 
any platform with IMR registers could justifiably

a) Tear down everything that's unlocked
b) Place a default IMR around the .text section

No reason it the world that that policy needs to be Galileo specific - 
and it's a valid argument to say - this behaviour can simply be an IMR 
policy in the kernel and less code for the same functionality, that adds 
consistency across x86 is a good thing.

I'll zap the Galileo platform code entirely for V2 unless there's a 
counter-argument from someone.

--
BOD

