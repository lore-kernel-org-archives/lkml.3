Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab3GDDmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:42:10 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51236 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933508Ab3GDDmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:42:08 -0400
Message-ID: <51D4EF6C.9040808@gmail.com>
Date: Thu, 04 Jul 2013 11:43:40 +0800
From: Light <sgsdxzy@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Intel_pstate: One Core always 100% C0 state and never scale down
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using a laptop with Intel Ivy bridge core i7 3610QM. I updated my 
kernel to 3.10 and started to use intel_pstate as scaling driver:
#cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
intel_pstate

However I find that one of my four cores is always in C0 state even when 
there is no activities. I monitored it using i7z:
Core [core-id]  :Actual Freq (Mult.)      C0%   Halt(C1)%  C3 %   C6 %   
C7 %  Temp
         Core 1 [0]:       3288.24 (32.97x)      99.7       0 0       
0       0    83
         Core 2 [1]:       3138.62 (31.47x)         1       0 0       
0    99.7    74
         Core 3 [2]:       3175.46 (31.84x)         1    0.891 0       
0      99    76
         Core 4 [3]:       3177.34 (31.86x)         1    0.21 0       
0    99.3    71

Also cpu frequencies never scale down, resulting in very high temp.
#cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
powersave

It does say powersave, and my cpu is capable of 1.20Ghz to 3.30Ghz

I don't know if I misconfigured or misunderstood something. Can someone 
tell me why?
Thanks!
