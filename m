Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaBRTV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:21:26 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:46613 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaBRTVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:21:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140218190245.GA27455@kroah.com>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
	<1392674322-9036-2-git-send-email-john.stultz@linaro.org>
	<20140218190245.GA27455@kroah.com>
Date: Tue, 18 Feb 2014 11:21:24 -0800
Message-ID: <CALAqxLXTvZqVj7n0PSMa8WrWUeycFVa+b8KvtQvk=r2eYBPa_Q@mail.gmail.com>
Subject: Re: [PATCH 01/14] staging: binder: Fix death notifications
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:02 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Feb 17, 2014 at 01:58:29PM -0800, John Stultz wrote:
>> From: Arve Hjønnevåg <arve@android.com>
>>
>> The change (008fa749e0fe5b2fffd20b7fe4891bb80d072c6a) that moved the
>> node release code to a separate function broke death notifications in
>> some cases. When it encountered a reference without a death
>> notification request, it would skip looking at the remaining
>> references, and therefore fail to send death notifications for them.
>>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Cc: Colin Cross <ccross@android.com>
>> Cc: Arve Hjønnevåg <arve@android.com>
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Signed-off-by: Arve Hjønnevåg <arve@android.com>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>  drivers/staging/android/binder.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> As this broke in 3.10, shouldn't this go to staging-linus and get
> backported to the stable trees too?

Right. I rearranged this fix to be in the front of this series because
of this, and mentioned in the cover letter that it might be considered
for 3.14. If that's considered ok, then it can be pushed to stable as
well.

thanks
-john
