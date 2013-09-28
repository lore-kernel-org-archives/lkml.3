Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3I1ONP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 10:13:15 -0400
Received: from mout.gmx.net ([212.227.17.22]:62372 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab3I1ONN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 10:13:13 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Sat, 28 Sep 2013 16:13:10 +0200
From: "Tibor Billes" <tbilles@gmx.com>
Message-ID: <20130928141310.302530@gmx.com>
MIME-Version: 1.0
Subject: Re: Unusually high system CPU usage with recent kernels
To: paulmck@linux.vnet.ibm.com
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
Content-Transfer-Encoding: 8bit
X-GMX-UID: oYY0ckkXeSEqJL5QQHchJSl+IGRvb8AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I was just wondering if you received my last mail, because I haven't heard from
you for a while now.

Tibor


> ----- Original Message -----
> From: Tibor Billes
> Sent: 09/14/13 03:59 PM
> To: paulmck@linux.vnet.ibm.com
> Subject: Re: Unusually high system CPU usage with recent kernels
> 
> > From: Paul E. McKenney Sent: 09/13/13 02:19 AM
> > On Wed, Sep 11, 2013 at 08:46:04AM +0200, Tibor Billes wrote:
> > > > From: Paul E. McKenney Sent: 09/09/13 10:44 PM
> > > > On Mon, Sep 09, 2013 at 09:47:37PM +0200, Tibor Billes wrote:
> > > > > > From: Paul E. McKenney Sent: 09/08/13 08:43 PM
> > > > > > On Sun, Sep 08, 2013 at 07:22:45PM +0200, Tibor Billes wrote:
> > > > > > > Good news Paul, the above patch did solve this issue :) I see no extra
> > > > > > > context switches, no extra CPU usage and no extra compile time.
> > > > > > 
> > > > > > Woo-hoo!!! ;-)
> > > > > > 
> > > > > > May I add your Tested-by to the fix?
> > > > > 
> > > > > Yes, please :)
> > > > 
> > > > Done! ;-)
> > > > 
> > > > > > > Any idea why couldn't you reproduce this? Why did it only hit my system?
> > > > > > 
> > > > > > Timing, maybe? Another question is "Why didn't lots of people complain
> > > > > > about this?" It would be good to find out because it is quite possible
> > > > > > that there is some other bug that this patch is masking -- or even just
> > > > > > making less probable.
> > > > > 
> > > > > Good point!
> > > > > 
> > > > > > If you are interested, please build one of the old kernels but with
> > > > > > CONFIG_RCU_TRACE=y. Then run something like the following as root
> > > > > > concurrently with your workload:
> > > > > > 
> > > > > > sleep 10
> > > > > > echo 1 > /sys/kernel/debug/tracing/events/rcu/enable
> > > > > > sleep 0.01
> > > > > > echo 0 > /sys/kernel/debug/tracing/events/rcu/enable
> > > > > > cat /sys/kernel/debug/tracing/trace > /tmp/trace
> > > > > > 
> > > > > > Send me the /tmp/trace file, which will probably be a few megabytes in
> > > > > > size, so please compress it before sending. ;-) A good compression
> > > > > > tool should be able to shrink it by a factor of 20 or thereabouts.
> > > > > 
> > > > > Ok, I did that. Twice! The first is with commit
> > > > > 910ee45db2f4837c8440e770474758493ab94bf7, which was the first bad commit
> > > > > according to the bisection I did initially. Second with the current
> > > > > mainline 3.11. I have little idea of what the fields and lines mean in
> > > > > the RCU trace files, so I'm not going to guess if they are essentially
> > > > > the same or not, but it may provide more information to you. Both files
> > > > > were created by using a shell script containing the commands you
> > > > > suggested.
> > > > 
> > > > So traces both correspond to bad cases, correct? They are both quite
> > > > impressive -- looks like you have quite the interrupt rate going on there!
> > > > Almost looks like interrupts are somehow getting enabled on the path
> > > > to/from idle.
> > > > 
> > > > Could you please also send along a trace with the fix applied?
> > > 
> > > Sure. The attached tar file contains traces of good kernels. The first is with
> > > version 3.9.7 (no patch applied) which was the last stable kernel I tried and
> > > didn't have this issue. The second is version 3.11 with your fix applied.
> > > Judging by the size of the traces, 3.11.0+ is still doing more work than
> > > 3.9.7.
> > 
> > Indeed, though quite a bit less than the problematic traces.
> > 
> > Did you have all three patches applied to 3.11.0, or just the last one?
> > If the latter, could you please try it with all three?
> 
> Only the last one was applied to 3.11.0. The attachement now contains the
> RCU trace with all thee applied. It seems to be smaller in size, but still
> not close to 3.9.7.
> 
> > > > > I'm not sure about LKML policies about attaching not-so-small files to
> > > > > emails, so I've dropped LKML from the CC list. Please CC the mailing
> > > > > list in your reply.
> > > > 
> > > > Done!
> > > > 
> > > > Another approach is to post the traces on the web and send the URL to
> > > > LKML. But whatever works for you is fine by me.
> > > 
> > > Sending directly to you won again :) Could you please CC the list in your
> > > reply?
> > 
> > Done! ;-)
> 
> Could you please CC the list in your reply again? :)
> 
> Tibor

