Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3IZGgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:36:36 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44284 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3IZGgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:36:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRQRGGpShFiTBP7OZ8txhKG_i-1_s=AAGPQx+JzTkW=0Lg@mail.gmail.com>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<564c8b1f073dc396b54866a2220b09b7869289f4.1379779777.git.viresh.kumar@linaro.org>
	<CAMbhsRQRGGpShFiTBP7OZ8txhKG_i-1_s=AAGPQx+JzTkW=0Lg@mail.gmail.com>
Date: Thu, 26 Sep 2013 12:06:04 +0530
Message-ID: <CAKohpokmdk2xJ6OFz68Oen4YRqC5MptSn7tGmH+nZrn9hoLmbA@mail.gmail.com>
Subject: Re: [PATCH 14/21] cpuidle: coupled: don't compare cpu masks unnecessarily
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Colin Cross <ccross@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 05:55, Colin Cross <ccross@google.com> wrote:
> I don't agree with this.  This patch is a tiny optimization in code
> that is rarely called, and it moves a final sanity check somewhere
> that it might get missed if the code were later refactored.

This is what we are doing for the first cpu of coupled-cpus:
if (WARN_ON(!cpumask_equal(&dev->coupled_cpus, &dev->coupled_cpus)))
    coupled->prevent++;

i.e. comparing a variable to itself :)

And I believe my patch puts the sanity check at the right place (where
we are using coupled from existing CPUs.. And that is where it should
have been since the beginning)..

If people miss this during code re-factoring, then it would be even more
stupid on the part of Author and Reviewer.. And if it still gets missed
then this is not the only place where we need to worry about such stuff..

This is present everywhere in our code.. You can't really some part of
code to some place and leave the other as-is.. The change is supposed
to be more logical and so funny mistakes must be caught during reviews.
