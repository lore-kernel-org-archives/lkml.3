Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3FLKNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:13:23 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2820 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab3FLKNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:13:22 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51B849BA.6000802@broadcom.com>
Date: Wed, 12 Jun 2013 12:13:14 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: event filtering with trace-cmd
X-WSS-ID: 7DA6982A2L831973834-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

I wanted to filter my debug events getting only one specific level. So I 
followed the instruction found online, but I get a parse error.

Running on 3.10-rc1 using trace-cmd 1.0.3. Should I upgrade?

Regards,
Arend
----8<-----------------------------------------------------------------
events/brcmfmac/brcmf_dbg# cat format
name: brcmf_dbg
ID: 1133
format: 

         field:unsigned short common_type;       offset:0;       size:2; 
signed:0;
         field:unsigned char common_flags;       offset:2;       size:1; 
signed:0;
         field:unsigned char common_preempt_count;       offset:3; 
  size:1; signed:0;
         field:int common_pid;   offset:4;       size:4; signed:1;

         field:u32 level;        offset:8;       size:4; signed:0;
         field:__data_loc char[] func;   offset:12;      size:4; signed:1;
         field:__data_loc char[] msg;    offset:16;      size:4; signed:1;
 

print fmt: "%s: %s", __get_str(func), __get_str(msg)

# sudo trace-cmd record -e brcmfmac:brcmf_dbg -f 'level & 0x40000'
disable all
enable brcmfmac:brcmf_dbg
path = /sys/kernel/debug/tracing/events/brcmfmac/brcmf_dbg/enable
(level & 0x40000)
^
parse_error: Invalid operator

trace-cmd: Invalid argument
   Failed filter of 
/sys/kernel/debug/tracing/events/brcmfmac/brcmf_dbg/filter

