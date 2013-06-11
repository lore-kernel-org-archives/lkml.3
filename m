Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3FKXUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 19:20:25 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44171 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3FKXUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 19:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW9gt_E_rtVhk4bMO_EnGaLbRqca0xQosQBc7KuEtEDQXQ@mail.gmail.com>
References: <1369944137-30948-1-git-send-email-jwerner@chromium.org>
	<4844834.TBe7kS6ocA@vostro.rjw.lan>
	<CAODwPW9gt_E_rtVhk4bMO_EnGaLbRqca0xQosQBc7KuEtEDQXQ@mail.gmail.com>
Date: Tue, 11 Jun 2013 16:20:19 -0700
X-Google-Sender-Auth: NL-sMTeZsu-u0ygPr7NW46wMYyM
Message-ID: <CAODwPW8Je0-W5nwvAmWasvwGejWHoeQnaPi8AeDe9s71mQVE7g@mail.gmail.com>
Subject: Re: [PATCH] PM / Sleep: Print last wakeup source on failed
 wakeup_count write
From: Julius Werner <jwerner@chromium.org>
To: Julius Werner <jwerner@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Todd Poynor <toddpoynor@google.com>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending as plain text... sorry for the spam, Gmail just likes to
silently mess up my settings every once in a while.

On Tue, Jun 11, 2013 at 4:17 PM, Julius Werner <jwerner@chromium.org> wrote:
>
>> This is going to be done in the autosleep case too, which I'm slightly
>> concerned about.
>>
>> If you wanted to cover /sys/power/wakeup_count only, it would be better
>> to put that into wakeup_count_store(), but perhaps you wanted to cover
>> autosleep too?
>
>
> Hmm... no, I did not really take the autosleep case into account. I can't
> quite tell with what frequency the autosleep try_to_suspend() handler on an
> active system would run... do you think it might be a useful feature to have
> there, or would it lead to logspam?
>
> I can move it to wakeup_count_store() if you prefer, but then I will have to
> turn print_active_wakeup_sources() into an exported function, which is also
> a little inconvenient.
