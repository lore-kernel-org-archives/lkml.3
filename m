Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaEPBYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 21:24:10 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59934 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaEPBYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 21:24:09 -0400
Message-ID: <537568B5.9060208@gmail.com>
Date: Thu, 15 May 2014 20:24:05 -0500
From: David Hagood <david.hagood@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug? Older 32 bit program (CivCTP) no longer works under 64 bit kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an old native Linux 32 bit copy of Civilization: Call to Power. 
It used to work under a 64 bit environment back in the 3.0.x days. 
However, under recent versions (>3.5) it no longer runs - it complains 
that it cannot find certain files in the directory. The exact same code 
will run just fine under a 32 bit version of 3.11. I have a Pentium II 
as well as the Core 2 Duo, both running Ubuntu 14.04, same version of 
the kernel other than one is 32 bit and one is 64 bit. I've copied the 
files over from the 32 bit machine, where it runs, to the 64 bit 
machine, where it does not. I've even gone so far as to copy all the 
system 32 bit libraries into the CivCTP directory, and forced the 
program to use them (including using the ld-linux.so loader from that 
directory) - so in theory it's all the same user space libraries running 
- the only difference that I can see is that one kernel is 64 bit and 
one is 32 bit.

Running strace on the program shows that the directories being searched 
for game assets are corrupted:

16218 stat64("/home/wowbaggr/CivCTP/ctdata/englisish/uidata/keymap.txt", 
  <unfinished ...>

Note the "englisish" rather than "english".

I'm looking for any suggestions on where to look for what might cause 
such an issue - what can I do to start tracking this down.
