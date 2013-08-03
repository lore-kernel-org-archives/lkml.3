Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3HCBE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:04:56 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:49962 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3HCBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:04:54 -0400
MIME-Version: 1.0
In-Reply-To: <3682340.ddGL4l7l22@vostro.rjw.lan>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
	<3682340.ddGL4l7l22@vostro.rjw.lan>
Date: Fri, 2 Aug 2013 20:04:52 -0500
Message-ID: <CAMP44s0wg2wxWAo9WRXzxxhG_RJ_rfOkPchCoUf7VVradczuqQ@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 6:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, August 02, 2013 02:37:09 PM Felipe Contreras wrote:
>> If the _BCL package is descending, the first level (br->levels[2]) will
>> be 0, and if the number of levels matches the number of steps, we might
>> confuse a returned level to mean the index.
>>
>> For example:
>>
>>   current_level = max_level = 100
>>   test_level = 0
>>   returned level = 100
>>
>> In this case 100 means the level, not the index, and _BCM failed. But if
>> the _BCL package is descending, the index of level 0 is also 100, so we
>> assume _BQC is indexed, when it's not.
>>
>> This causes all _BQC calls to return bogus values causing weird behavior
>> from the user's perspective. For example: xbacklight -set 10; xbacklight
>> -set 20; would flash to 90% and then slowly down to the desired level
>> (20).
>>
>> The solution is simple; test anything other than the first level (e.g.
>> 1).
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>
> Looks reasonable.
>
> Aaron, what do you think?

Aaron has a similar patch does many more checks. I think we should add
more checks, but I think those should go into a separate patch.

This patch alone fixes a real problem, which is rather urgent to fix,
and I did it this way so it's trivial to review and merge.

-- 
Felipe Contreras
