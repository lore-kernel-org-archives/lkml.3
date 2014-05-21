Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaEUJl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:41:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65414 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaEUJlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <537C7348.7060202@arm.com>
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>
	<ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org>
	<537C7348.7060202@arm.com>
Date: Wed, 21 May 2014 15:11:39 +0530
Message-ID: <CAKohpo=F5gSPvVSAX=qePnudxiuKWLKGTZy8vd80=MJxESWJZQ@mail.gmail.com>
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 15:05, Sudeep Holla <sudeep.holla@arm.com> wrote:
> As Rafael mentioned it's better to have a wrapper function to hide these
> details. You should consider the fact that of_init_opp_table returns -EINVAL
> if
> CONFIG_PM_OPP not defined as well as when the list is invalid in the DT.
> IMO we can return -ENOSYS if not implemented(i.e. !CONFIG_PM_OPP)

I didn't understood Rafael's comment as I couldn't figure out if he is just
pointing to CONFIG_** or some arch specific thing..

But it looks more obvious that he asked me something similar to what you
are saying :)

Why do we need to return anything? Let that function have return type 'void'?
Also would it make sense to move this into it as well?

cpu->dev.of_node = of_get_cpu_node(num, NULL);
