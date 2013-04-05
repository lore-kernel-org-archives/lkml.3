Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162679Ab3DETwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:52:54 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:52394 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162587Ab3DETww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:52:52 -0400
Message-ID: <1365191567.3585.10.camel@thor.lan>
Subject: Re: n_tty_write() going into schedule but NOT coming out
From: Peter Hurley <peter@hurleysoftware.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Date: Fri, 05 Apr 2013 15:52:47 -0400
In-Reply-To: <515ADC96.7090908@synopsys.com>
References: <5156DC21.20901@synopsys.com> <5159925B.5050806@synopsys.com>
	 <1364829008.3617.21.camel@thor.lan> <515ADC96.7090908@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ --cc Ingo and Peter Z. as this is not scheduler-related]

On Tue, 2013-04-02 at 18:56 +0530, Vineet Gupta wrote:
> On 04/01/2013 08:40 PM, Peter Hurley wrote:
> > On Mon, 2013-04-01 at 19:27 +0530, Vineet Gupta wrote:
> >> Hi,
> >>
> >> Any thoughts: I observe the same issue even with CONFIG_PREEMPT and
> >> CONFIG_PREEMPT_COUNT

I'll see if I can reproduce this over the weekend on an old single-core
laptop I still have.

There were some race conditions in the N_TTY line discipline which I
recently fixed. Those changes are in linux-next. Can you test if this is
reproducible on linux-next?

Assuming I don't reproduce this on the laptop, the only other
explanation I can think of right now is that ARCLinux is not properly
handling signal-driven i/o (assuming the BusyBox /bin/sh uses SIGIO). Do
you know if there is anything special about the way ARCLinux handle
signals?

Regards,
Peter Hurley

