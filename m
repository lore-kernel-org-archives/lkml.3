Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCKC41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:56:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:19694 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752546AbaCKC4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:56:25 -0400
Date: Mon, 10 Mar 2014 22:56:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH RT 2/5] a few open coded completions
Message-ID: <20140310225623.0cad071a@gandalf.local.home>
In-Reply-To: <1394503606.23624.27.camel@deadeye.wl.decadent.org.uk>
References: <20131211003732.351606520@goodmis.org>
	<20131211003801.836995968@goodmis.org>
	<20131211144946.27d82a78@gandalf.local.home>
	<1394324841.2861.56.camel@deadeye.wl.decadent.org.uk>
	<20140310102928.7b2a2cfa@gandalf.local.home>
	<1394473962.23624.3.camel@deadeye.wl.decadent.org.uk>
	<20140310141449.6b99c7eb@gandalf.local.home>
	<1394503606.23624.27.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 02:06:46 +0000
Ben Hutchings <ben@decadent.org.uk> wrote:


> > I don't run a make allmodconfig as I do on my upstream work. Maybe I'll
> > have to add that to the mix.
> 
> You can enable all the affected code with:
> 
> CONFIG_HERMES=m
> CONFIG_ORINOCO_USB=m
> CONFIG_USB_GADGET=m
> CONFIG_USB_FUNCTIONFS=m
> CONFIG_USB_GADGETFS=m

Thanks, I ran an allmodconfig, and you're right, the orinoco driver
failed to compile on v3.2-rt. I ran allmodconfig on 3.10-rt and it
passed fine. Seems that one of the headers there pulls in swait.

Looking deeper, 3.10-rt has completion as a simple-wait, and
completion.h pulls in wait-simple.h, which is why it works there. 3.2
does not have completions there. I wonder if I should pull in the patch
that converts completions into swaits, and that may fix other locations
as well.

I'll give it a try.

Thanks,

-- Steve
