Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaKEAAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:00:42 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:54117 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKEAAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:00:40 -0500
Date: Tue, 4 Nov 2014 16:00:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Norbert Preining <preining@logic.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
In-Reply-To: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
Message-ID: <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com>
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Norbert Preining wrote:

> Dear all,
> 
> (please Cc)
> 
> since 3.18-rc started, regularly, but unpredictably, firefox
> (Debian iceweasel) goes completely boom to 100% CPU, and there
> is also a kernel task khugepaged doing the same.
> 
> I need to kill firefox, or better the X session to get it back to normal.
> 
> THe logs don't show any strange output
> 
> top's top process:
> 
> 27021 norbert   20   0 1351536 449868  88788 R 100.4  5.6   4:46.16 iceweasel   
>    35 root      39  19       0      0      0 R 100.0  0.0   2:41.10 khugepaged  
> 
> Switching back to 3.17 does Not* exhibit the same behaviour.
> 
> Is this a bug in Firefox/Iceweasel, or is there something luring in the
> kernel.
> 

If you have the ability to kill your X session, then you presumably are 
able to capture /proc/pid/stack for these pids to see where it is busy.  
It might also be helpful to see how the grep ^thp_ /proc/vmstat and 
grep ^compact_ /proc/vmstat counters change over time.
