Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3KKEnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 23:43:35 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:52499 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3KKEn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 23:43:27 -0500
MIME-Version: 1.0
In-Reply-To: <CADmjqpMG_UVbbmC4Yjveod2q9zHJ6LsxOAYzNZN4NBOr_qhN+Q@mail.gmail.com>
References: <1383791330-8289-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=2xjR=nr5hyMg9bve5_uVbV79R2FTxks0bLmL7kNV9Mg@mail.gmail.com>
	<CADmjqpNWYVxrXuo106rBuZeZ2BrkGFkmbMJ8jxi39c8kLiQ+iw@mail.gmail.com>
	<CAKohpon6DhiWMuszuznK4ZNCBTpy0_r3gGvTXCDMcktXpN3HEw@mail.gmail.com>
	<CADmjqpP4dxWoU_3dLzC5+JffvwnZaLV=uxFTghpMRoSL_85TrA@mail.gmail.com>
	<CAKohpo=Rq-Sds5FzVdxcAEb78sqemq5JCc3S+pc11mu_b_ZpNA@mail.gmail.com>
	<CADmjqpMG_UVbbmC4Yjveod2q9zHJ6LsxOAYzNZN4NBOr_qhN+Q@mail.gmail.com>
Date: Mon, 11 Nov 2013 10:13:26 +0530
Message-ID: <CAKohpomP61X_cymgZggMtmWjAhqG3VniEqw-rHstcBkwr5FYqQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: conservative: fix requested_freq reduction issue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <skarafotis@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2013 00:59, Stratos Karafotis <skarafotis@gmail.com> wrote:
> I removed the check you proposed in this commit 934dac1ea072 to avoid
> the duplicate check in cs_check_cpu and in dbs_cpufreq_notifier.
>
> I agree that we don't need dbs_cpufreq_notifier if we transfer checks in
> cs_check_cpu. But I'm not 100% sure if the notifier also covers
> other cases and if it can be safely removed.

It is there to take care of out-of-sync issues, and was introduced by this
commit, so probably it will stay as is:

commit a8d7c3bc2396aff14f9e920677072cb55b016040
Author: Elias Oltmanns <eo@nebensachen.de>
Date:   Mon Oct 22 09:50:13 2007 +0200

    [CPUFREQ] Make cpufreq_conservative handle out-of-sync events properly

    Make cpufreq_conservative handle out-of-sync events properly

    Currently, the cpufreq_conservative governor doesn't get notified when the
    actual frequency the cpu is running at differs from what cpufreq thought it
    was. As a result the cpu may stay at the maximum frequency after a s2ram /
    resume cycle even though the system is idle.

    Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
    Signed-off-by: Dave Jones <davej@redhat.com>
---
 drivers/cpufreq/cpufreq_conservative.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)
