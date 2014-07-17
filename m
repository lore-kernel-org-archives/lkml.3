Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbaGQMbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:31:10 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:63315 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbaGQMbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:31:08 -0400
Message-ID: <53C7C20D.6000501@linaro.org>
Date: Thu, 17 Jul 2014 07:31:09 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 1/4] printk: LOG_CONT and LOG_NEWLINE are separate
References: <1405531620-9983-1-git-send-email-elder@linaro.org> <1405531620-9983-2-git-send-email-elder@linaro.org> <20140717083918.GP6774@pathway.suse.cz>
In-Reply-To: <20140717083918.GP6774@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 03:39 AM, Petr Mládek wrote:
> On Wed 2014-07-16 12:26:57, Alex Elder wrote:
>> Two log record flags--LOG_CONT and LOG_NEWLINE--are never both set
>> at the same time in a log record flags field.  What follows is a
>> great deal of explanation that aims to prove this assertion.
> 
> It makes perfect sense. If you found a situation where both flags were
> set together, it would mean a bug. If a record ends with new line, it
> is not continuous and vice versa.

. . .

My earlier response basically argued for keeping the patch
as I originally proposed it.

That is still my plan.  However there is one more thing
that I have verified since posting it--I can make the
stronger assertion that LOG_CONT and LOG_NEWLINE are
mutually exclusive.  That is, not only will they never
be both set at the time, but one of them will always
be set.

Rather than add that as a new patch I'm going to rework
the explanation, and make one more small code change
to make this a little easier to see.

					-Alex
