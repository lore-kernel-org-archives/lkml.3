Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaCSFUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:20:47 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:46453 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaCSFUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <5328A21C.3010909@intel.com>
References: <16035918.jZXKnQ3yiq@vostro.rjw.lan>
	<1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com>
	<1394831037-15553-3-git-send-email-dirk.j.brandewie@intel.com>
	<CAOh2x=kFC5cwdYVgFCwNgqZAwWaE-CFQoyYizBuv1W6MOnQ9DA@mail.gmail.com>
	<53285FDB.40102@gmail.com>
	<532895DF.2090100@linux.vnet.ibm.com>
	<5328A21C.3010909@intel.com>
Date: Wed, 19 Mar 2014 10:50:44 +0530
Message-ID: <CAKohpomM5s0v+442Pyg2HFguJs3tXKTNWFnHCfJmRJpTPvY=3A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] intel_pstate: Set core to min P state during core offline
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrick Marlier <patrick.marlier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 01:14, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> There was no problem per se.  In stop() all I really needed to do is stop
> the
> timer and set the P state to MIN.
>
> At init time I need to allocate memory and start timer.  If stopping the
> timer
> and deallocating memory are separated then I need code in init() to detect
> this case.

Sorry, I didn't understood what exactly is special here :(

If we return failure from CPU_POST_DEAD for some reason without
calling exit() then you will have memory leak in your init() as we are
allocating memory without checking if we already have that (nothing wrong
in it though as other parts of kernel should handle things properly here).

Probably the situation would be exactly same if we divide the exit path into
stop and exit routines, which I still feel is the right way forward. Because
ideally cpufreq shouldn't call init() if it hasn't called exit() (If
it is doing that
right now then its wrong and can be fixed). And so you must do the cleanup
in exit()..
