Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646Ab3JQUUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:20:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50322 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762584Ab3JQUUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:20:33 -0400
Date: Thu, 17 Oct 2013 16:20:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd problem with FC19
Message-ID: <20131017162029.002485b1@gandalf.local.home>
In-Reply-To: <52604373.5010907@broadcom.com>
References: <525FD328.1040204@broadcom.com>
	<20131017144116.044f3aaf@gandalf.local.home>
	<52604373.5010907@broadcom.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 22:07:15 +0200
"Arend van Spriel" <arend@broadcom.com> wrote:


> > Does recording other traces work? Or is it only spicific to this module?
> 
> It seems a generic issue:
> 
> $ sudo trace-cmd record -e ext4:* ls
> /sys/kernel/debug/tracing/events/ext4/*/filter
> systemd-private-6pVB5L	systemd-private-KdpFqS	trace.dat.cpu0	trace.dat.cpu2
> systemd-private-9hedRD	trace.dat		trace.dat.cpu1	trace.dat.cpu3
> trace-cmd: Interrupted system call
>    recorder error in splice input
> trace-cmd: Interrupted system call
>    recorder error in splice input
> trace-cmd: Interrupted system call
>    recorder error in splice input
> trace-cmd: Interrupted system call
>    recorder error in splice input
> Kernel buffer statistics:
>    Note: "entries" are the entries left in the kernel ring buffer and 
> are not
>          recorded in the trace data. They should all be zero.
> 
> I got the modules properly signed so only OOT taint is set and it still 
> does not work.

You said this is an issue on Fedora 19?

I have a Fedora 19 VM, and did the following:

$ su
# yum install trace-cmd
# trace-cmd record -e ext4:* ls

and it all worked.

Now the difference is that I don't use sudo (I find it rather silly). 

Do you get the same error with 'su' as you do with 'sudo'?

-- Steve

