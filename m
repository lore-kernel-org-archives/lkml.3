Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3E3Oyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:54:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3E3Oyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:54:43 -0400
X-Authority-Analysis: v=2.0 cv=MNbiabll c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=f73XcKl29joA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=y5CGMQcehd0A:10 a=k5LshzCzX24ODCz3Bi4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369925681.26799.6.camel@gandalf.local.home>
Subject: Re: [PATCH] RFC: Set irq thread to RT priority on creation
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ivo Sieben <meltedpianoman@gmail.com>, RT <linux-rt-users@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 30 May 2013 10:54:41 -0400
In-Reply-To: <alpine.LFD.2.02.1305301602490.2905@ionos>
References: <1369915975-28797-1-git-send-email-meltedpianoman@gmail.com>
	 <alpine.LFD.2.02.1305301602490.2905@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 16:07 +0200, Thomas Gleixner wrote:

> > This patch solves an issue for me where a device driver is expected to handle an
> > interrupt immediatly after irq handlers are installed and interrupts enabled.
> 
> You miss to explain what kind of issue that is.

I could envision the case where the interrupt is initialized but doesn't
go off until much later. If it never ran, then it would still be in
SCHED_OTHER(), and that first interrupt could have a large delay.

-- Steve


