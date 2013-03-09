Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3CIIdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:33:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53025 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3CIIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:33:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
References: <20130307132819.GA31162@localhost> <87sj47t97s.fsf@xmission.com>
	<CADZ9YHhbvu8WYUMdDtpvkrZmLCD87fQ0Y0AcXdBaQB53=uPYYw@mail.gmail.com>
	<87d2v9q3sk.fsf@xmission.com>
	<CADZ9YHhPq7aWwmyBoEt+CsGnKfKTeZN1bCT-LtwtJxUaHGwJ=g@mail.gmail.com>
Date: Sat, 09 Mar 2013 00:33:00 -0800
In-Reply-To: <CADZ9YHhPq7aWwmyBoEt+CsGnKfKTeZN1bCT-LtwtJxUaHGwJ=g@mail.gmail.com>
	(Rakib Mullick's message of "Sat, 9 Mar 2013 09:54:45 +0600")
Message-ID: <877glhkm6b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Wbl0tnloLCiQOIHY5DbrKJpm/XY0XcVA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rakib Mullick <rakib.mullick@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [nsproxy] BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick <rakib.mullick@gmail.com> writes:

> On Fri, Mar 8, 2013 at 10:01 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> When a new task is created one of two things needs to happen.
>> A) A reference count needs to be added to the current nsproxy.
>> B) B a new nsproxy needs to be created.
>>
>> The way that code works today is far from a shiny example of totally
>> clear code but it is not incorrect.
>>
>> By moving get_nsproxy down below the first return 0, you removed taking
>> the reference count in the one case it is important.
>>
>> Arguably we should apply the patch below for clarity, and I just might
>> queue it up for 3.10.
>>
> This one is much more cleaner. One thing regarding this patch, can we
> check the namespace related flags at copy_namespace() call time at
> copy_process(), also get_nsproxy()? I think this will reduce some
> extra function call overhead and as you've mentioned get_nsproxy() is
> needed at every process creation.

If you can write a benchmark that can tell the difference, and the code
continues to be readable.  It would be worth making the change.

My gut says you are proposing an optimization that won't have
a measurable impact.

Eric
