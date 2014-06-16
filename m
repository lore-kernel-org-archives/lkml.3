Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaFPGIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:08:11 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:56265 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589AbaFPGIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:08:09 -0400
X-Yandex-Uniq: 413e21be-5238-421d-a431-c5e9a47b2a1a
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 16 Jun 2014 10:08:04 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
Message-ID: <20140616060804.GA9394@stfomichev-desktop.yandex.net>
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
 <1402412694-5996-2-git-send-email-stfomichev@yandex-team.ru>
 <87ppif9c3y.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppif9c3y.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It was because, as I said, my system doesn't have pread64 syscall.. you
> missed to decrease rec_argc when skipping invalid events. :)
Thanks, missed that!

> After fixing the problem, I could run timechart and generate an
> output.svg file.  But it doesn't show any IO activity.. process info was
> there in grey boxes (rect.process3) but no color boxes.  I also tried
> recording with ping and dd, but the result was same.  I suspect it's
> because of some mis-calculation of position or size of the boxes.
Did you try it with all patches applied? Because if you have really fast
IO you can miss it (unless you applied perf timechart: add more options
to IO mode).
Can you somehow share your perf.data with me? I'll check what's going
on.
