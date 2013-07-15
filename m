Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3GOTa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:30:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3GOTa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:30:26 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0OGBnBv_dtgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ringC-sgREwA:10 a=3N3TVzL0jjNlTnjXb_oA:9 a=QEXdDO2ut3YA:10 a=4UBfssCpKOcA:10 a=o7NNL0RPAFoA:10 a=5A4zu3kuagsA:10 a=SsdK35KI7XIA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373916620.17876.182.camel@gandalf.local.home>
Subject: Re: nohz: Warn if the machine can not perform nohz_full
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Jul 2013 15:30:20 -0400
In-Reply-To: <20130715185624.GB1706@redhat.com>
References: <20130715170859.GA25570@redhat.com>
	 <20130715171800.GD6442@somewhere> <20130715172423.GA27745@redhat.com>
	 <20130715173848.GA1066@redhat.com>
	 <1373914182.17876.165.camel@gandalf.local.home>
	 <20130715185624.GB1706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 14:56 -0400, Dave Jones wrote:
> On Mon, Jul 15, 2013 at 02:49:42PM -0400, Steven Rostedt wrote:
>  
> Is a printk not enough for that purpose ? Tainting the kernel is kinda anti-social.
> 

printk's don't usually get peoples attention. Taints and warnings do. If
the hardware doesn't allow for nohz-full, and the only way to enable it
is via kernel command line, how do you scream to the user that it isn't
going to work.

We could do a large banner saying:

***************************************************************
***************************************************************
***************************************************************
***************************************************************
***                    UNSTABLE TSC                         ***
***                NO_HZ_FULL disabled                      ***
***************************************************************
***************************************************************
***************************************************************
***************************************************************


And not do the warning. Maybe that will get peoples attentions?

But then again, this could be lost in the boot up if the box prints a
lot of data.

-- Steve


