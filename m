Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbbAKQAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:00:41 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60879 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbAKQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:00:40 -0500
Message-ID: <54B29E26.6070807@gmail.com>
Date: Sun, 11 Jan 2015 10:00:38 -0600
From: David Hagood <david.hagood@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: On a tickless kernel, how to convert jiffies into a real time
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a kernel configured for full tickless operation, how can a user space 
program take a value reported by the kernel in jiffies and convert it 
into a meaningful wall clock time?

I am asking specifically in terms of parsing the output from 
/proc/net/xt_recent/*, but there are other places where user space gets 
jiffies from the kernel, so this is a bit more generic.

I have seen several suggestions of just reading the parameters via 
sysconf(_SC_CLK_TCK), but that does not work - that reports 1000 jiffies 
per second, but that is NOT the value that is being used by the kernel - 
as best as I can tell by inspection, it seems to be running somewhere 
around 2145 ticks per second, and seems to vary based upon what the 
system is doing. If the value does indeed vary, then there's really no 
way to compute a jiffies value to wall clock time save at the instant 
that jiffies value is captured.

