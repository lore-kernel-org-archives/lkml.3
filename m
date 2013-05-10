Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3EJQrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:47:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab3EJQrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:47:22 -0400
Message-ID: <518D2346.10805@ti.com>
Date: Fri, 10 May 2013 11:41:42 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Green <andy.green@linaro.org>
Subject: Re: [RFC 2/3] mailbox: Introduce a new common API
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com> <1367086474-28614-1-git-send-email-jaswinder.singh@linaro.org> <51847070.8040400@ti.com> <CAJe_Zhdbnpu9n46s6L5KNFuTb2K87j+V4htKkmHYtBJ6w+etxQ@mail.gmail.com> <518840A2.5000205@ti.com> <CAJe_ZhedTM_wU7NGH_QRrL=O3JSYjt9ENDLYpOEQNSX3f7OgBA@mail.gmail.com> <518976B9.2030605@ti.com> <CAJe_ZhfpLQzDBSx=2VbD3W-499-g1JOovGDuFwxkE-Cq=HQDww@mail.gmail.com> <518AFB1F.7010409@ti.com> <CAJe_ZheEZo7Akri40ixBhWzeefABxiJXG1Juc4zQOPNQqyahUw@mail.gmail.com> <518C3CE9.1010603@ti.com> <CAJe_ZhfFs5svKPABHWdKA83+LhxA5+Q3LKuJyqyRj_4SMMm_hg@mail.gmail.com>
In-Reply-To: <CAJe_ZhfFs5svKPABHWdKA83+LhxA5+Q3LKuJyqyRj_4SMMm_hg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jassi,

>>> See how mailbox_startup() tries to balance mbox->ops->startup() and
>>> mailbox_fini() the mbox->ops->shutdown()  That's very fragile and the
>>> cause of imbalance between rpm enable/disable, unless your clients are
>>> buggy.
>>
>> Yeah, it is kinda messed up in the existing code, the startup defined
>> there is really for the controller and not the link, and that's why you
>> see all the ref-counting balancing logic. The rpm enable/disable being
>> called is on the controller's dev, not the link's dev - maybe that's
>> what confused you.
>>
> I wrote the driver for this api, so I do realize the rpm is on
> controller. Links are not devices anyways.
> 

You might be missing the minor detail. The pm_runtime_enable is in
startup, which is called for every link. So, I get an unbalanced
warning, when I have
	ipc_request_channel(client1);  -> link1.startup
	ipc_request_channel(clinet2);  -> link2.startup

Anyway, it is a non-issue since I understand the context and the fix.

regards
Suman



