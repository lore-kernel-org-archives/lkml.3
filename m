Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaHQKNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 06:13:09 -0400
Received: from srv2.trombetti.net ([65.254.53.252]:3818 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133AbaHQKNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 06:13:07 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Aug 2014 06:13:07 EDT
Message-ID: <53F07EB8.5060201@shiftmail.org>
Date: Sun, 17 Aug 2014 12:06:48 +0200
From: Ethan Wilson <ethan.wilson@shiftmail.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: How to get kernel stack trace if process not blocked?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,
cat /proc/pid/stack shows the kernel call stack of a process, and this 
is so good, but it will show just 0xffffffffffffffff if the process is 
running in kernel space and not blocked (sleeping).
With just an 0xffffffffffffffff  AFAIU it is also impossible to 
distinguish a process running in kernel space from a process running in 
user space.

It would be *very* useful to get the kernel stack trace for a running 
process, even if imprecise, or at least knowing the name of the kernel 
function executing now (top of the stack). Why is it not doable?

I tried to disable CONFIG_SCHED_OMIT_FRAME_POINTER but it didn't allow 
to print the stack from /proc/pid/stack anyway. What is the benefit of 
disabling such kernel option (i.e. having the frame pointer)?

I guessed that maybe with EIP from /proc/pid/stat it is possible to do 
something like that but I can't find much information on how to do that.

Thanks for any information
EW

