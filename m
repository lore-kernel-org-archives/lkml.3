Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab3LIXrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:47:31 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49121 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LIXra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:47:30 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-68-52a65690c4d3
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 09/14] tools lib traceevent: Get rid of die() in add_right()
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-10-git-send-email-namhyung@kernel.org>
	<CAKb7Uvhhg2siBURLxTb2jgW_-5AUeK_yqRpEJgi0HW12zQTMyg@mail.gmail.com>
	<87fvq2mrw1.fsf@sejong.aot.lge.com>
	<20131209113256.67442b2a@gandalf.local.home>
Date: Tue, 10 Dec 2013 08:47:28 +0900
In-Reply-To: <20131209113256.67442b2a@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 9 Dec 2013 11:32:56 -0500")
Message-ID: <87y53tlh7z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Mon, 9 Dec 2013 11:32:56 -0500, Steven Rostedt wrote:
> On Mon, 09 Dec 2013 15:59:26 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Hi Ilia,
>> 
>> On Mon, 9 Dec 2013 01:28:26 -0500, Ilia Mirkin wrote:
>> > That should probably be
>> >
>> > if (!op->str.buffer)
>> 
>> Argh.. you're right!
>
> I was thinking that it was better to do it Namhyung's way, with:
>
> 	if (op->str.buffer == NULL)
>
> than my preferred way of:
>
> 	if (!op->str.buffer)
>
> because I thought this mistake is more prevalent with my way. But It's
> good to know that this bug happens regardless of which way you
> prefer ;-)

Well, while I prefer explicit "buf == NULL" style, I was using "!buf"
style at that time since the previous line of "!op->str.val" already
used that style so that's why the typo came in.  Just FYI. :)

Thanks,
Namhyung
