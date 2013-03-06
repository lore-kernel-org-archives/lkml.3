Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3CFNte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:49:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3CFNtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:49:32 -0500
Message-ID: <51374968.4070805@canonical.com>
Date: Wed, 06 Mar 2013 14:49:28 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Christine Spang <christine.spang@oracle.com>
CC: Takashi Iwai <tiwai@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
        alsa-devel@alsa-project.org, Jamie Iles <jamie.iles@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] Make snd_BUG_ON() always evaluate and return
 the conditional expression.
References: <1362434579-7733-1-git-send-email-christine.spang@oracle.com> <s5h8v62gqt0.wl%tiwai@suse.de> <51365862.9050401@oracle.com>
In-Reply-To: <51365862.9050401@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-03-05 21:41, Christine Spang skrev:
> On 03/05/2013 04:05 AM, Takashi Iwai wrote:
>> At Mon,  4 Mar 2013 17:02:59 -0500,
>> Christine Spang wrote:
>>> Having snd_BUG_ON() only evaluate its conditional when CONFIG_SND_DEBUG
>>> is set leads to frequent bugs, since other similar macros in the kernel
>>> have different behavior. Let's make snd_BUG_ON() act like those macros
>>> so it will stop being accidentally misused.
>>>
>>> Signed-off-by: Christine Spang <christine.spang@oracle.com>
>> Sounds reasonable.  The dependency on CONFIG_SND_DEBUG was for
>> allowing more optimization, but since we use this for more places than
>> expected, this change would be safer indeed.
>>
>> If no one has objection, I'll apply it for 3.10 kernel.

If snd_BUG_ON now works like WARN_ON rather than BUG_ON (at least it 
does with this change, if I understand things right), maybe we should 
rename it to snd_WARN_ON for consistency?


-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic

