Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3J3Wjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:39:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47329 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3J3Wjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:39:52 -0400
From: Kenneth Lee <nek.in.cn@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Subject: An small ftrace enhancement idea
Date: Wed, 30 Oct 2013 15:39:50 -0700
Message-Id: <4A791BBD-EBBE-420F-8199-E4BAAF6A3C46@gmail.com>
Cc: linux-kernel@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
X-Mailer: Apple Mail (2.1816)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Steven,

I want to add a new function to ftrace subsystem. Sometimes, we will face such a problem: system do not response to the input on time one to two times everyday. It is not easy to capture because it rarely happens. So I want to add a function to the kernel. If I have such problem, I insert a kernel module, who add a hook to the position that receive the input and another to the position that response to the input (with a session id if necessary). And I can compare the time between them and if the period is longer then a pre-set threshold, I can give a signal to a user helper application (maybe a script waiting on the file), which then can save the trace event to a file for later inspection.

 

The user helper script may look like this:

 

#/bin/sh

 

echo ¡®sched:*¡¯ > /sys/kernel/debug/tracing/set_event

modprobe delay_inspector.ko threshold=500

cat /sys/kernel/debug/tracing/waiter #wait for signal

cp /sys/kernel/debug/tracing/trace /var/log/delay_infomation

 

 

It looks like a standalone function. But I don¡¯t have place to put it. Do you think I can implement it in ftrace? And do you think if there are better solution?

 

Thank you.

 

Kenneth Lee