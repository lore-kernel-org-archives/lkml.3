Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3FLK7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:59:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34841 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab3FLK7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:59:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julius Werner <jwerner@chromium.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Todd Poynor <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] PM / Sleep: Print last wakeup source on failed wakeup_count write
Date: Wed, 12 Jun 2013 13:08:30 +0200
Message-ID: <2495031.eoWHqoAo1O@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAODwPW9gt_E_rtVhk4bMO_EnGaLbRqca0xQosQBc7KuEtEDQXQ@mail.gmail.com>
References: <1369944137-30948-1-git-send-email-jwerner@chromium.org> <4844834.TBe7kS6ocA@vostro.rjw.lan> <CAODwPW9gt_E_rtVhk4bMO_EnGaLbRqca0xQosQBc7KuEtEDQXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 11, 2013 04:17:35 PM Julius Werner wrote:
> > This is going to be done in the autosleep case too, which I'm slightly
> > concerned about.
> >
> > If you wanted to cover /sys/power/wakeup_count only, it would be better
> > to put that into wakeup_count_store(), but perhaps you wanted to cover
> > autosleep too?
> >
> 
> Hmm... no, I did not really take the autosleep case into account. I can't
> quite tell with what frequency the autosleep try_to_suspend() handler on an
> active system would run... do you think it might be a useful feature to
> have there, or would it lead to logspam?

On Android systems it may be really frequent, because they try to suspend
very aggressively.  That's why I asked about it.

> I can move it to wakeup_count_store() if you prefer, but then I will have
> to turn print_active_wakeup_sources() into an exported function, which is
> also a little inconvenient.

That's OK.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
