Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3FLQWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:22:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3FLQWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:22:02 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_8TXWqlxb2sA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=qPXK9W7imzkA:10 a=2tgSz25buB-j1T_Bcz4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371054120.9844.259.camel@gandalf.local.home>
Subject: Re: event filtering with trace-cmd
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Jun 2013 12:22:00 -0400
In-Reply-To: <51B849BA.6000802@broadcom.com>
References: <51B849BA.6000802@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 12:13 +0200, Arend van Spriel wrote:
> Hi Steven
> 
> I wanted to filter my debug events getting only one specific level. So I 
> followed the instruction found online, but I get a parse error.
> 
> Running on 3.10-rc1 using trace-cmd 1.0.3. Should I upgrade?

I would recommend upgrading regardless, but that's not an issue here.

> 
> Regards,
> Arend
> ----8<-----------------------------------------------------------------
> events/brcmfmac/brcmf_dbg# cat format
> name: brcmf_dbg
> ID: 1133
> format: 
> 
>          field:unsigned short common_type;       offset:0;       size:2; 
> signed:0;
>          field:unsigned char common_flags;       offset:2;       size:1; 
> signed:0;
>          field:unsigned char common_preempt_count;       offset:3; 
>   size:1; signed:0;
>          field:int common_pid;   offset:4;       size:4; signed:1;
> 
>          field:u32 level;        offset:8;       size:4; signed:0;
>          field:__data_loc char[] func;   offset:12;      size:4; signed:1;
>          field:__data_loc char[] msg;    offset:16;      size:4; signed:1;
>  
> 
> print fmt: "%s: %s", __get_str(func), __get_str(msg)
> 
> # sudo trace-cmd record -e brcmfmac:brcmf_dbg -f 'level & 0x40000'
> disable all
> enable brcmfmac:brcmf_dbg
> path = /sys/kernel/debug/tracing/events/brcmfmac/brcmf_dbg/enable
> (level & 0x40000)
> ^
> parse_error: Invalid operator
> 

The record -f command passes the filter into the kernel
file /sys/kerne/debug/tracing/events/brcmfmac/brcmf_dbg/filter, and the
error is actually coming from the kernel itself. Looking at the code, we
do not currently accept binary operations. Although, it shouldn't be too
hard to add. I may go and implement it for 3.11.


Thanks!

-- Steve

> trace-cmd: Invalid argument
>    Failed filter of 
> /sys/kernel/debug/tracing/events/brcmfmac/brcmf_dbg/filter


