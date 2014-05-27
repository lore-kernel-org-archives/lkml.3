Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaE0AEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:04:06 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:49697 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaE0AED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <3104462.ta2PpIfF9J@vostro.rjw.lan>
References: <cover.1400736536.git.viresh.kumar@linaro.org>
	<6379a5109bf6b4875cc1656b025f9b8186bbb91a.1400736536.git.viresh.kumar@linaro.org>
	<3104462.ta2PpIfF9J@vostro.rjw.lan>
Date: Tue, 27 May 2014 05:34:01 +0530
Message-ID: <CAKohponagSjOVbn-C64yh7=py9kE0m2VGbdquo_1+UzbPFsJ+w@mail.gmail.com>
Subject: Re: [PATCH V3 4/8] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2014 05:02, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Do you actually use cpu anywere in this function for anything other than
> just accessing cpu->dev?  If not, why not to pass cpu->dev to it and
> move it somewhere in the OPP core?

We are also using it for cpu->dev_id, but that's not so important. This
routine wouldn't have existed if you wouldn't have asked for it. It is
just a wrapper over of_init_opp_table, which also has a dummy
implementation when its not supported.

So, it might not be worth enough for any other code to use it. :)
And so I added it here.

Let me know how/where do you want it and I will resend it quickly.
