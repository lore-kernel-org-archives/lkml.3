Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab3IBRdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:33:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10126 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab3IBRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:33:47 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=sh6OYvBCkPUA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Yk6RV3B9-jIA:10 a=tHz9FfFoAAAA:8 a=UbsFRRgfAAAA:8 a=WGW3EOYdAAAA:8 a=fIe0RpJzoax8M9H0VeAA:9 a=CjuIK1q_8ugA:10 a=lA4bp537W6cA:10 a=6O0IECtVFhoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 2 Sep 2013 13:33:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Paul Bolle <pebolle@tiscali.nl>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/trace: Correcting and extending
 tracepoint documentation
Message-ID: <20130902133345.1cddd3f1@gandalf.local.home>
In-Reply-To: <5224C4B7.6090003@citrix.com>
References: <1377421194.2737.118@driftwood>
	<5224C4B7.6090003@citrix.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Sep 2013 18:02:47 +0100
Zoltan Kiss <zoltan.kiss@citrix.com> wrote:


> > Why? (Both why do you need to #include a header outside a multiple
> > inclusion guard, and why is the additional header needed at all in
> > _every_ subsystem trace header?)
> I see only one inclusion guard here, the one above. define_trace.h 
> should take effect at only one place, where CREATE_TRACE_POINTS is 
> defined, to create the tracepoints exactly once. However I don't see as 
> well why it should be outside protection. Maybe because the intentional 
> header reinclusion in it?

Because if it was inside the protection you can miss the
CREATE_TRACE_POINTS define. These headers can be included by other
headers (although they probably shouldn't be). But that's the point of
the protection isn't it? In case multiple headers include the file?

Anyway, lets say the header was include earlier, thus you can have this:


#include <trace/foo.h> // include by another header

#define CREATE_TRACE_POINTS

#include <trace/foo.h>


Now if the include of define_trace.h was inside the protection, it will
not get included again, and no trace points would be created.

-- Steve
