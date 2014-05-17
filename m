Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbaEQAEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:04:47 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53417 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbaEQAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:04:46 -0400
Message-ID: <5376A79B.30604@linaro.org>
Date: Fri, 16 May 2014 17:04:43 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org> <20140425140421.GA7933@localhost>
In-Reply-To: <20140425140421.GA7933@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 07:04 AM, Miroslav Lichvar wrote:
> On Thu, Apr 24, 2014 at 04:04:34PM -0700, John Stultz wrote:
>> Continuing the sporadic work on improving the timekeeping
>> frequency steering logic when NOHZ is enabled, I've made a number
>> of changes to my re-implementation of Miroslav's patch (most
>> recently posted here: https://lkml.org/lkml/2014/2/12/401 ),
>> and I'm getting much closer results in the simulator.
> Thanks, in my initial testing it seems to be working well. The results
> from the simulator are much better than with the previous patch.
>
>> Compared with Miroslav's patch, this avoids doing any extra
>> divisions, and instead approximates the correction
>> logarithmically.
> Hm, doesn't that basically make the code a software implementation of
> division? It seems it needs about 4-8 iterations to get to the final
> result.
>
> I didn't measure it, but I think with this change it now may be close
> or possibly even slower than my patch. The extra division and
> multiplication in my patch are used only when the tick length changes
> (normally once per second), otherwise the update is very cheap.

Fair enough. I've moved to your division method for the last patch in my
series (instead of looping).

I'm still not 100% convinced we need it, since I'm still worried the
error seen in the simulator with the default options is somewhat
contrived. For example, since it regularly skips 4k ticks, that
exaggerates the accumulated error in the approximation case. But we can
discuss this further w/ the new patch series.

thanks!
-john



