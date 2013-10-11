Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab3JKQa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:30:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60639 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3JKQay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:30:54 -0400
Message-ID: <525827B3.9080003@canonical.com>
Date: Fri, 11 Oct 2013 12:30:43 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
CC: Kamal Mostafa <kamal@canonical.com>, linux-kernel@vger.kernel.org,
        dudl@cypress.com, git@status.e4ward.com, tim.gardner@canonical.com,
        linux-input@vger.kernel.org
Subject: [PATCH 1/1][Resend] Input: cypress_ps2 - Return zero finger count
 if palm is detected.
References: <cover.1379968154.git.joseph.salisbury@canonical.com>	 <007c09ae4ef7f72ffb657de0fb3854fcbc6d88f0.1379968154.git.joseph.salisbury@canonical.com> <1380571922.15513.29.camel@fourier>
In-Reply-To: <1380571922.15513.29.camel@fourier>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 04:12 PM, Kamal Mostafa wrote:
> On Tue, 2013-09-24 at 11:44 -0400, Joseph Salisbury wrote:
>> BugLink: http://bugs.launchpad.net/bugs/1229361
>>
>> This patch sets the finger count to 0 in the case of palm contact.
>>
>> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com> (maintainer:INPUT (KEYBOARD,...,commit_signer:2/2=100%)
>> Cc: Henrik Rydberg <rydberg@euromail.se> (maintainer:INPUT MULTITOUCH...)
>> Cc: Kamal Mostafa <kamal@canonical.com> (commit_signer:2/2=100%)
>> Cc: Dudley Du <dudl@cypress.com> (commit_signer:2/2=100%)
>> Cc: Kyle Fazzari <git@status.e4ward.com> (commit_signer:1/2=50%)
>> Cc: Tim Gardner <tim.gardner@canonical.com> (commit_signer:1/2=50%)
>> Cc: linux-input@vger.kernel.org (open list:INPUT (KEYBOARD,...)
>> Cc: linux-kernel@vger.kernel.org (open list)
>> Cc: stable@vger.kernel.org
> This patch works fine: eliminates stream of junk driver messages with no
> ill effects.
>
> Tested-by: Kamal Mostafa <kamal@canonical.com>
>
>  -Kamal
>
>
>> ---
>>  drivers/input/mouse/cypress_ps2.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
>> index 45b3eda..95b2c40 100644
>> --- a/drivers/input/mouse/cypress_ps2.c
>> +++ b/drivers/input/mouse/cypress_ps2.c
>> @@ -441,7 +441,7 @@ static int cypress_get_finger_count(unsigned char header_byte)
>>  			case 2: return 5;
>>  			default:
>>  				/* Invalid contact (e.g. palm). Ignore it. */
>> -				return -1;
>> +				return 0;
>>  		}
>>  	}
>>  
>> @@ -460,7 +460,7 @@ static int cypress_parse_packet(struct psmouse *psmouse,
>>  
>>  	contact_cnt = cypress_get_finger_count(header_byte);
>>  
>> -	if (contact_cnt < 0) /* e.g. palm detect */
>> +	if (contact_cnt < 0)
>>  		return -EINVAL;
>>  
>>  	report_data->contact_cnt = contact_cnt;
Hi Dmitry and Henrik,

Have you had a chance to review this patch to consider it for inclusion
in mainline?

Thanks,

Joe

