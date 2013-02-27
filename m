Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222Ab3B0POz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:14:55 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64595 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943Ab3B0POx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130227151036.GC22383@htj.dyndns.org>
References: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
	<20130227151036.GC22383@htj.dyndns.org>
Date: Wed, 27 Feb 2013 20:44:52 +0530
Message-ID: <CAKohponvsL7BsabqkLS6W4EHx1N7=Ua04JwZksztPqwzW2ze=w@mail.gmail.com>
Subject: Re: [PATCH 1/3] workqueue: define mod_scheduled_delayed_work[_on]() helpers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2013 20:40, Tejun Heo <tj@kernel.org> wrote:
> So, the intention is to just let people use system_wq.  We no longer
> have single system-wide workqueue and we don't wanna add different
> variants matching each system wq.  schedule_work() and friends were
> already there so I'm leaving those alone but I don't really want to
> add another set of rather meaningless wrappers.  Please just use
> system_wq with mode_delayed_work*().

Even i thought the same initially but got these wrappers so that any updates
to workqueue used in schedule_work later on would simply work here as the
commiter would fix these too but fixing user drivers can be tricky.

To keep things aligned probably i should replace schedule_work() with
queue_work() and use system_wq there too..

--
viresh
