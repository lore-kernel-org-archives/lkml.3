Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaCGNgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:36:37 -0500
Received: from www.meduna.org ([92.240.244.38]:34623 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaCGNgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:36:35 -0500
Message-ID: <5319CB58.4070708@meduna.org>
Date: Fri, 07 Mar 2014 14:36:24 +0100
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>, wg@grandegger.com,
        linux-can@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: FlexCAN on i.MX28 interrupt flooding retrying send
References: <53197E8A.5050409@meduna.org> <53198753.8000900@pengutronix.de>
In-Reply-To: <53198753.8000900@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-03-07 14:36:30
X-Connected-IP: 95.105.163.217:11789
X-Message-Linecount: 67
X-Body-Linecount: 51
X-Message-Size: 2614
X-Body-Size: 1875
X-Received-Count: 1
X-Recipient-Count: 5
X-Local-Recipient-Count: 5
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.03.2014 09:46, Marc Kleine-Budde wrote:

> Adding the linux-can mailinglist to Cc.

I am not subscribed so maybe that's why the original mail
did not get through - I did Cc: linux-can@vger.kernel.org

> Your kernel is missing the patch:
> 
> e358784 can: flexcan: fix mx28 detection by rearanging OF match table
> 
> With this patch the CAN core properly detected as an mx28, so that bus
> errors stay disabled (unless you enable them). If you need bus errors to
> detect not connected CAN busses, you need another patchset berr_limit,
> which is not yet mainline. I can repost it here, if you need it.

Ah ok.

Thank you, this probably points me to the right direction - I'll try
to implement this behaviour in my kernel (unfortunately
I cannot move to more recent one at the moment).

On 07.03.2014 09:40, Wolfgang Grandegger wrote:

> Maybe there is something wrong with you platform code or DTS file. What
> kernel are you using and how is the DTS can node defined in your DTS file?

This is a the 3.4.77 kernel with the realtime patches and without
the device tree, so these settings are missing and the patch does
not apply.

On 07.03.2014 09:32, Matthias Klein wrote:

> I made a similar observation on an i.MX537 with the 3.12.12-rt19
> kernel: I see the same interrupt flooed when the bus is
> disconnected.
>
> What do you mean with "kills the machine"? I have a high interrupt
> load, but the machine is still responsive.

In my case the ssh connection became hung or updated once per several
seconds etc. In one case it was even necessary to ifconfig down/up
the ethernet interface (NAPI overload? - no idea). The exact behaviour
might be related to the realtime patches - we need guaranteed response
times and runaway interrupt processing hogging the CPU at the realtime
priority is a problem.

Many thanks
-- 
                                      Stano

