Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713Ab3JQUHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:07:23 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1899 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669Ab3JQUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:07:22 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <52604373.5010907@broadcom.com>
Date: Thu, 17 Oct 2013 22:07:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd problem with FC19
References: <525FD328.1040204@broadcom.com>
 <20131017144116.044f3aaf@gandalf.local.home>
In-Reply-To: <20131017144116.044f3aaf@gandalf.local.home>
X-WSS-ID: 7E7E9CE51R0101609463-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/13 20:41, Steven Rostedt wrote:
> On Thu, 17 Oct 2013 14:08:08 +0200
> "Arend van Spriel"<arend@broadcom.com>  wrote:
>
>> Hi Steven,
>>
>> When tracing I get these error messages and no trace data is recorded. I
>> also cloned the trace-cmd repo and tried that with the same result. I
>> think the kernel configuration looks ok, but adding it.
>>
>> I use it almost daily on Ubuntu system, but trying Fedora for a change.
>> I do have a difference with kernel taint with my driver loaded:
>>
>> Ubuntu	4096	(OOT module loaded, ie. my driver)
>> Fedora	4098	(OOT *and* forced module?)
>>
>> 'forced module' probably caused by:
>> [10808.074823] Request for unknown module key 'Fedora kernel signing
>> key: 8661dbf3061bfa70eb76d61691cec200318534b4' err -11
>>
>> Would that explain my issue?
>>
>> Regards,
>> Arend
>>
>> ---8<----------------------------------------------------
>> $ sudo trace-cmd record -e brcmfmac:*
>> /sys/kernel/debug/tracing/events/brcmfmac/*/filter
>> Hit Ctrl^C to stop recording
>> ^Ctrace-cmd: Interrupted system call
>> trace-cmd: Interrupted system call
>>       recorder error in splice inputrecorder error in splice input
>
> I haven't seen this before.
>
> Was the brcmfmac module the one that was forced loaded?
>
> Does recording other traces work? Or is it only spicific to this module?

It seems a generic issue:

$ sudo trace-cmd record -e ext4:* ls
/sys/kernel/debug/tracing/events/ext4/*/filter
systemd-private-6pVB5L	systemd-private-KdpFqS	trace.dat.cpu0	trace.dat.cpu2
systemd-private-9hedRD	trace.dat		trace.dat.cpu1	trace.dat.cpu3
trace-cmd: Interrupted system call
   recorder error in splice input
trace-cmd: Interrupted system call
   recorder error in splice input
trace-cmd: Interrupted system call
   recorder error in splice input
trace-cmd: Interrupted system call
   recorder error in splice input
Kernel buffer statistics:
   Note: "entries" are the entries left in the kernel ring buffer and 
are not
         recorded in the trace data. They should all be zero.

I got the modules properly signed so only OOT taint is set and it still 
does not work.

Regards,
Arend

> -- Steve
>
>>
>> trace-cmd: Interrupted system call
>>     recorder error in splice input
>> trace-cmd: Interrupted system call
>>     recorder error in splice input
>> Kernel buffer statistics:
>>     Note: "entries" are the entries left in the kernel ring buffer and
>> are not
>>           recorded in the trace data. They should all be zero.
>>
>
>


