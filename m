Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaLASvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:51:45 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:55892 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaLASvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:51:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stefan Agner <stefan@agner.ch>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "sre@kernel.org" <sre@kernel.org>, "fkan@apm.com" <fkan@apm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
Date: Mon, 01 Dec 2014 19:50:40 +0100
Message-ID: <3594295.ivTLMMcK6I@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141201174100.GC22708@leverpostej>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch> <e5c5a44c84b95c4e48ed01c4dcffd35a@agner.ch> <20141201174100.GC22708@leverpostej>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:me9OByuvrgEdVjfq92Y3NCVfH/LUa13QjkXLjQvYo6R
 B2z7vzCkpuKAbQWBgDgSMQ2MQR0KiqaWFMK1olwtqbmboDNPfR
 HIeY+8A+wfOBGWiUk8TnAk2A15pJZWjrIcVzcEouaLuiFUHXlG
 LrwhepP0kZNlWbZNOo/3DzNwRln8MIf2gMAlcFG7ARw35N+5fA
 1aPG/si9ifDmZ3DZab3M2YhGdegTQ90yjv2+peHuThC4inP8Ql
 LQMGe55zG827MEoVvsUWVKAIoucak8P4zhBI5pRUydzFBfvP/5
 ePsRhFmXsi5dLMu1c8XMbGLbIxiav+dHmJ4l1lHX4+pGHw2LfV
 Q2KCNcEx9lzze00FIdmI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 17:41:00 Mark Rutland wrote:
> Otherwise, I would imagine that most systems have a single preferred
> mechanism with some possible fallback(s), for which a single
> preferred-poweroff property might suffice, and has better interaction
> w.r.t. priority (in that it should _always_ be tried first). Even that's
> difficult to reconcile with FW bindings though, especially EFI (which we
> sometimes must use in preference for variable storage and capsule
> updates).

The preferred-poweroff property sounds better to me, too. I can see
two ways of doing that though, and I'm not sure which one you mean.
Would you put that as a bool property into the device that does the reboot,
or would you put it as reference into the /chosen or /aliases node?

I think the latter would be better as it avoids any ambiguity, but
either way would work.

	Arnd
