Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3F1Bal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:30:41 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55202 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3F1Bak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:30:40 -0400
Message-ID: <51CCE703.8070800@ahsoftware.de>
Date: Fri, 28 Jun 2013 03:29:39 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay
 registering as rtc into a work
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de> <1371724776-5572-1-git-send-email-holler@ahsoftware.de> <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org> <51CB5E6B.109@ahsoftware.de>
In-Reply-To: <51CB5E6B.109@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2013 23:34, schrieb Alexander Holler:
> Am 26.06.2013 21:55, schrieb Andrew Morton:
>> On Thu, 20 Jun 2013 12:39:36 +0200 Alexander Holler <holler@ahsoftware.de> wrote:

>>> +static void hid_time_register_rtc_work(struct work_struct *work)
>>> +{
>>> +	struct hid_time_state *time_state =
>>> +		container_of(work, struct hid_time_workts, work)
>>> +			->time_state;
>>> +	struct platform_device *pdev = time_state->callbacks.pdev;
>>
>> Ick.  When the initialisers overflow 80 cols, the fix is easy: don't
>> use initalisers:
>>
>> 	struct hid_time_state *time_state;
>> 	struct platform_device *pdev;
>>
>> 	time_state = container_of(work, struct hid_time_workts, work)->time_state;
>> 	pdev = time_state->callbacks.pdev;
>>
>
> Sorry, but it's long ago since I had to use a DOS machine and I still
> don't use a phone to write source, therefor I'm not very skilled in
> writing readable source with meaningfull names in max. 72 (80-8) chars
> per line. But I will work hard to relearn those long forgotten skills,
> they might become handy again, when PCs with monitors got finally
> replaced by phones and tablets with small screens. ;)

To do other poor patch submitters which don't use a video terminal too a 
favor, I've decided it might make sense to describe the workflow which 
is responsible for the above stuff which makes you cry so often. It 
isn't that I don't know that I don't have to use initializers, I know C 
since 3 decades.

The following happens here:

- I'm writing source/patches without limiting myself to 80x25 chars.
- Then I'm executing the insulting and must be one of the most hated 
piece of software callled checkpatch.pl.
- It tells me to place or delete spaces here and cut lines there.
- I do exactly that, while having my brain turned off (self-protection)

Therefor stuff the like the above happens. It isn't badwill, 
incompetence or inability.

Regards,

Alexander Holler
