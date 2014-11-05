Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaKEGvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:51:53 -0500
Received: from plane.gmane.org ([80.91.229.3]:58383 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaKEGvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:51:52 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra 
	<public-peterz-wEGCiKHe2LqWVfeAwA7xHQ@plane.gmane.org>
Cc: Pawel Moll <public-pawel.moll-5wv7dgnIgG8@plane.gmane.org>,
        Namhyung Kim 
	<public-namhyung-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org>,
        Richard Cochran 
	<public-richardcochran-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Steven Rostedt 
	<public-rostedt-nx8X9YLhiw1AfugRpC6u6w@plane.gmane.org>,
        Ingo Molnar <public-mingo-H+wXaHxf7aLQT0dZR+AlfA@plane.gmane.org>,
        Paul Mackerras 
	<public-paulus-eUNUBHrolfbYtjvyW6yDsg@plane.gmane.org>,
        Arnaldo Carvalho de Melo 
	<public-acme-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org>,
        John Stultz 
	<public-john.stultz-QSEj5FYQhm4dnm+yROfE0A@plane.gmane.org>,
        Masami Hiramatsu 
	<public-masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@plane.gmane.org>,
        Christopher Covington 
	<public-cov-sgV2jX0FEOL9JmXXK+q4OQ@plane.gmane.org>,
        David Ahern 
	<public-dsahern-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Thomas Gleixner 
	<public-tglx-hfZtesqFncYOwBW4kG4KsQ@plane.gmane.org>,
        Tomeu Vizoso 
	<public-tomeu-XCtybt49RKsYaV1qd6yewg@plane.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        "linux-api-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-api-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>
Subject: Re: [PATCH v3 2/3] perf: Userspace event
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	<1415060918-19954-3-git-send-email-pawel.moll@arm.com>
	<87ppd35vbk.fsf@sejong.aot.lge.com>
	<1415119331.24819.19.camel@arm.com>
	<20141104184031.GM10501@worktop.programming.kicks-ass.net>
Date: Wed, 05 Nov 2014 15:36:31 +0900
In-Reply-To: <20141104184031.GM10501@worktop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 4 Nov 2014 19:40:31 +0100")
Message-ID: <878ujqw3v4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Peter and Pawel,

On Tue, 4 Nov 2014 19:40:31 +0100, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 04:42:11PM +0000, Pawel Moll wrote:
>> 
>> 1. I'm wrong and the record doesn't have to be padded to make it 8 bytes
>> aligned. Then I can drop the additional size field.
>
> No, you're right, we're supposed to stay 8 byte aligned.
>
>> 2. I could impose a limitation on the prctl API that the data size must
>> be 8 bytes aligned. Bad idea in my opinion, I'd rather not.
>
> Agreed.
>
>> 3. The additional size (for the data part) field stays. Notice that
>> PERF_SAMPLE_RAW has it as well :-)
>
> Right, with binary data there is no other day. With \0 terminated
> strings there won't be a problem, but I think we decided we wanted to
> allow any binary blow.

Ah, I missed that.  Thank you guys for explanation.

Thanks,
Namhyung

