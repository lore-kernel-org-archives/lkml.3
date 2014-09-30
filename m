Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaI3BD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:03:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64555 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbaI3BDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:03:25 -0400
X-AuditID: cbfee68d-f79296d000004278-07-542a015917e3
Date: Tue, 30 Sep 2014 01:03:21 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [RFC PATCH] extcon: Fix sleeping in atomic context after
 connecting USB cable
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        =?euc-kr?Q?=BF=EC=BB=F3=C1=A4?= <sangjung.woo@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?euc-kr?Q?=C7=D1=C1=F8=B1=B8?= <jg1.han@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140930005941739@myungjoo.ham
Msgkey: 20140930005941739@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20140930005941739@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <3502148.197971412039000491.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkRDeSUSvE4HmLgMXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4MrY9uk6U8EX7Yqupn3sDYwPtLoYOTmEBNQlFi05yQZiSwiYSPxb
	/5oZwhaTuHBvPRtEzVJGiQ/P82Fq3v1aztTFyAUUn8Mocfd3OyNIgkVAVWJmz0X2LkYODjYB
	PYmZn5NBTGGBOInlX2VATBEBY4lVC31AOpkFfjNLHPjbxAIxXklizb5XYDavgKDEyZlPWEDq
	JYAmrpvjBhFWk/h65hALxAUSErOmX2CFsHklZrQ/hYrLSUz7ugbqemmJ87M2MMJ8svj7Y6g4
	v8Sx2zuYIGwBialnDkLVaEk82fQfqoZPYs3Ctyww9btOLWeG2XV/y1wmmBu2tjwBu4FZQFFi
	SvdDdghbS+LLj31sqF4BsR0lDny7xgjyu4TARA6JG11HmCYwKs1CUjcLyaxZSGYhq1nAyLKK
	UTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzApnP73rHcH4+0D1ocYBTgYlXh4NyzVCBFiTSwr
	rsw9xGgKjKSJzFKiyfnA1JNXEm9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVANjbZI5B+Nl9njzby1HJ0x4vz2p44iY79HurE+vr7FmTJipymsTpVOTEfZT
	wf7yve7or09svsWfEM9e1Z/L+vbId63sbWXP7kxmyfA3rks902t24dD7WxZPXWc3ri+NvrV7
	brDNf0GGgDk9+UGOOid+CDrWZ/76vtnNb9aHGt3lnllTlu7eyJGpxFKckWioxVxUnAgAf/C3
	FQUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tXt1IRq0Qg29f2C0u75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsa2
	T9eZCr5oV3Q17WNvYHyg1cXIySEkoC6xaMlJNhBbQsBE4t2v5UwQtpjEhXvrgeJcQDVzGCXu
	/m5nBEmwCKhKzOy5yN7FyMHBJqAnMfNzMogpLBAnsfyrDIgpImAssWqhD0gns8BvZokDf5tY
	IFYpSazZ9wrM5hUQlDg58wkLSL0E0MR1c9wgwmoSX88cYoG4QEJi1vQLrBA2r8SM9qdQcTmJ
	aV/XMEPY0hLnZ21ghLl48ffHUHF+iWO3d0B9IiAx9cxBqBotiSeb/kPV8EmsWfiWBaZ+16nl
	zDC77m+ZywRzw9aWJ2A3MAsoSkzpfsgOYWtJfPmxjw3VKyC2o8SBb9cYJzDKzkKSmoWkfRaS
	dmQ1CxhZVjGKphYkFxQnpVcY6hUn5haX5qXrJefnbmIEp6BnC3cwfjlvfYhRgINRiYeXY4VG
	iBBrYllxZe4hRgkOZiURXrkdmiFCvCmJlVWpRfnxRaU5qcWHGE2BUTaRWUo0OR+YHvNK4g2N
	jU3MTEwtTSwMTM2VxHnv3kwKEhJITyxJzU5NLUgtgulj4uCUamCM336a6dhZ2Vdl9xa+Pcvc
	IzvP18l00sK7jU9ERQ7eP/H/yYmfEXHr9mUqBX1N+OXlJrdXb8uiRbYSovH2cg+nxF2Las/Z
	aBZv9u9Zafm77Gd/78e3iUoVxihMn7zb0XdNzP4b5xPfS0x7cL2ea8MCnmmVSgovWqJq9Tb1
	ubXrfdFrPBoYm2+rxFKckWioxVxUnAgATk59olcDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8U13VZL018164

> On pon, 2014-09-29 at 04:25 +0000, «‘∏Ì¡÷ wrote:
> > >   
> > >  Kernel built with extcon and charger-manager.
> > > 
> > > After connecting the USB cable sleeping function was called from atomic
> > > context:
> > > [   63.328648] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
> > []
> > > [   63.388743] Workqueue: events max14577_muic_irq_work
> > > [   63.393707] [<c00167a4>] (unwind_backtrace) from [<c0012c08>] (show_stack+0x10/0x14)
> > > [   63.401422] [<c0012c08>] (show_stack) from [<c06232ec>] (dump_stack+0x70/0xbc)
> > > [   63.408625] [<c06232ec>] (dump_stack) from [<c0629d0c>] (mutex_lock_nested+0x24/0x410)
> > > [   63.416525] [<c0629d0c>] (mutex_lock_nested) from [<c0354474>] (regmap_read+0x30/0x60)
> > > [   63.424424] [<c0354474>] (regmap_read) from [<c0406b84>] (max14577_charger_get_property+0x1e4/0x250)
> > > [   63.433535] [<c0406b84>] (max14577_charger_get_property) from [<c0403834>] (is_ext_pwr_online+0x30/0x6c)
> > > [   63.442994] [<c0403834>] (is_ext_pwr_online) from [<c0404a54>] (charger_extcon_notifier+0x40/0x70)
> > > [   63.451934] [<c0404a54>] (charger_extcon_notifier) from [<c044cbe4>] (_call_per_cable+0x40/0x4c)
> > > [   63.460704] [<c044cbe4>] (_call_per_cable) from [<c0051560>] (notifier_call_chain+0x64/0x128)
> > > [   63.469209] [<c0051560>] (notifier_call_chain) from [<c0051640>] (raw_notifier_call_chain+0x18/0x20)
> > > [   63.478321] [<c0051640>] (raw_notifier_call_chain) from [<c044d0fc>] (extcon_update_state+0xa8/0x204)
> > > [   63.487522] [<c044d0fc>] (extcon_update_state) from [<c044e5f8>] (max14577_muic_chg_handler+0xdc/0x180)
> > > [   63.496897] [<c044e5f8>] (max14577_muic_chg_handler) from [<c044e924>] (max14577_muic_irq_work+0x7c/0xd8)
> > > [   63.506445] [<c044e924>] (max14577_muic_irq_work) from [<c004480c>] (process_one_work+0x198/0x66c)
> > > [   63.515385] [<c004480c>] (process_one_work) from [<c0044d4c>] (worker_thread+0x38/0x564)
> > > [   63.523455] [<c0044d4c>] (worker_thread) from [<c004c4ec>] (kthread+0xcc/0xe8)
> > > [   63.530661] [<c004c4ec>] (kthread) from [<c000f1f8>] (ret_from_fork+0x14/0x3c)
> > > [   63.543926] charger_manager: Set current limit of CHARGER : 450000uA ~ 450000uA
> > > [   63.548870] extcon-port jack: jack event CHGDET=usb
> > > [   63.550592] extcon-port jack: jack event CHGDET=charger
> > > [   64.188607] charger-manager charger-manager@0: Failed to get battery temperature
> > > [   64.200684] charger-manager charger-manager@0: CHARGING
> > > 
> > > The first sleeping function is is_ext_pwr_online()
> > > (drivers/power/charger-manager.c). The atomic context initiating the
> > > flow is set up in extcon_update_state() (drivers/extcon/extcon-class.c).
> > > 
> > > The extcon_update_state() uses spin locks which are not necessary
> > > because the function is not called from interrupt service routines.
> > > Instead, the extcon_update_state() is called from:
> > > 1. Threaded interrupt handlers.
> > > 2. Work queues.
> > > 
> > > Replace the spin lock with mutex and update the documentation of this
> > > function.
> > 
> > No. You've done it in the opposite way.
> > 
> > update_state is often called in a interrupt handler that cannot sleep.
> > 
> > For the context you've mentioned, we'd need workqueue invoked by
> > _call_per_cable or notifier callback.
> 
> I'm still not convinced that calling raw_notifier_chain under spin lock
> in extcon_update_state() is safe. I think it is not safe because current
> design implies silently that all notifiers registered with
> extcon_register_notifier() must not sleep.

Even if we remove spin_lock completely, whenever an interrupt handler
notifies state change via extcon, you will get the similar BUG messages.
The mutex of I2C won't work in that context.

> 
> _call_per_cable() is just one of ways to trigger this issue.
> 

Thus, in order to satisfy both interrupt handlers and sleeping notifyees,
we can add an option to let _call_per_cable() use workqueue for those who
want to sleep.


Cheers,
MyungJooˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
