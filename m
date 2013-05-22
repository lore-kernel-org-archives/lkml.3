Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3EVNML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:12:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38426 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3EVNMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:12:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 22 May 2013 15:11:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: stephan.gatzka@gmail.com
Cc: linux1394-devel@lists.sourceforge.net, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
Message-ID: <20130522151146.3d2595be@stein>
In-Reply-To: <24da2e78e684e560c5aa034cebd3e26b@gatzka.org>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
	<20130521222817.3626b59d@stein>
	<24da2e78e684e560c5aa034cebd3e26b@gatzka.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 22 Stephan Gatzka wrote:
[I wrote:]
> > Wait a minute --- I seem to be reading of Xenomai RT extensions for the
> > first time in this thread.  Has the problem been reproduced on a mainline
> > kernel too?  (Mainline plus Ralf's firewire upper layer driver maybe, but
> > without any other 3rd party stuff please.  Actually the issue should be
> > reproducible even without an upper layer driver performing
> > fw_iso_resource_manage in fw_workqueue context, shouldn't it?)
> 
> Unfortunately it's not that easy. While I agree that it should be 
> reproducible just with mainline stuff, we have to force our system into 
> the situation that it "thinks" it's under memory pressure to hand over 
> the work to the rescuer thread. It looks that a simple printk from a 
> different driver might lead to that situation on our system.
[...]

I retract my request to get it retested with mainline since a) the
analysis has clearly shown that a mainline bug is at the root of the
problem, and b) Ralf confirmed now that one of the possible fixes (using
two queues) does in fact work for him like the theory says how it should
work for mainline.
-- 
Stefan Richter
-=====-===-= -=-= =-==-
http://arcgraph.de/sr/
