Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3F3ARN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 20:17:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3F3ARM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 20:17:12 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=UGEXCrDjMHA6Ouco5OoA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372551429.18733.363.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Sat, 29 Jun 2013 20:17:09 -0400
In-Reply-To: <CA+55aFz8rz=c8DsNHpBJW1K=FH-ztuPAMNOoGfM6HQyZByQ9mQ@mail.gmail.com>
References: <20130624173510.GA1321@redhat.com>
	 <20130625153520.GA7784@redhat.com> <20130626191853.GA29049@redhat.com>
	 <20130627002255.GA16553@redhat.com> <20130627075543.GA32195@dastard>
	 <20130627100612.GA29338@dastard> <20130627125218.GB32195@dastard>
	 <20130627152151.GA11551@redhat.com> <20130628011301.GC32195@dastard>
	 <20130628035825.GC29338@dastard> <20130629201311.GA23838@redhat.com>
	 <CA+55aFz8rz=c8DsNHpBJW1K=FH-ztuPAMNOoGfM6HQyZByQ9mQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-29 at 15:23 -0700, Linus Torvalds wrote:

> Does the machine recover? Because if it does, I'd be inclined to just
> ignore it. Although it would be interesting to hear what triggers this
> - normal users - and I'm assuming you're still running trinity as
> non-root - generally should not be able to trigger stop-machine
> events..

It may be that we are live locking the system. If you enable too much
debug (I see lockdep is on as well), when the system is stressed, it
starts doing too much debugging and stops forward progress.

Dave, can you reproduce these hangs when you disable lockdep?

-- Steve


