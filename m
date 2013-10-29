Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3J2JwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:52:05 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:59939 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab3J2JwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:52:03 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 29 Oct 2013 13:51:56 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] perf timechart: add support for -P and -T in
 timechart recording
Message-ID: <20131029095156.GE3406@stfomichev-desktop>
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
 <1382439412-23713-6-git-send-email-stfomichev@yandex-team.ru>
 <87hac05vo6.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hac05vo6.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It should be ARRAY_SIZE(old_power_args).
Thanks :-)

> Do we really need to separate the option and usage for record?  AFAICS
> it does exactly same thing..
Yes, we do. Some options which are defined for timechart are undefined
for record (like -i, -o, etc), so we want to get an error in case of wrong
options.

And we separate usage, because it's different in timechart:
		"perf timechart [<options>] {record}",

and record:
		"perf timechart record [<options>]",

We may share usage, but we need it to be something (confusing?) like:
		"perf timechart [<options>] {record [<options>]}",
