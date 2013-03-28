Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3C1N25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:28:57 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65500 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3C1N24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:28:56 -0400
Message-ID: <51544594.2010509@suse.cz>
Date: Thu, 28 Mar 2013 14:28:52 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Mathieu Poirier <mathieu.poirier@linaro.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Out-of-bound access in sysrq
References: <51541C9B.4000802@suse.cz> <51544367.2020904@linaro.org>
In-Reply-To: <51544367.2020904@linaro.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 02:19 PM, Mathieu Poirier wrote:
> On 13-03-28 04:34 AM, Jiri Slaby wrote:
>> Guys,
>>
>> how is this supposed to work?
>>
>> #define SYSRQ_KEY_RESET_MAX     20 /* Should be plenty */
>> static unsigned short sysrq_reset_seq[SYSRQ_KEY_RESET_MAX];
>> ...
>> unsigned short platform_sysrq_reset_seq[] __weak = { KEY_RESERVED };
>> ...
>> static inline void sysrq_register_handler(void)
>> {
>> ...
>>         for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
>>                 key = platform_sysrq_reset_seq[i];
>>                 if (key == KEY_RESERVED || key > KEY_MAX)
>> ...
>>
>>
>>
>>
>> i runs from 0 to 19 incl., but platform_sysrq_reset_seq, if not
>> overriden, is of size 1, so?
>>
>> thanks,
>>
> 
> Unless I'm missing something, 'i' won't go higher than '0' since the
> first element of platform_sysrq_reset_seq is set to KEY_RESERVED and in
> such case the 'break' is executed.

Of course, I was apparently sleeping yet. Sorry for the noise!

-- 
js
suse labs
