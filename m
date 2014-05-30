Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaE3DIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:08:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:2685 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751919AbaE3DIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:08:35 -0400
Date: Thu, 29 May 2014 23:08:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 1/2] ftrace: Make saved_cmdlines use seq_read
Message-ID: <20140529230828.4d10eb3d@gandalf.local.home>
In-Reply-To: <20140220084431.3839.51793.stgit@yunodevel>
References: <20140220084428.3839.59555.stgit@yunodevel>
	<20140220084431.3839.51793.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 17:44:31 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Current tracing_saved_cmdlines_read() implementation is naive;
> simply allocate a big buffer, construct output data on the
> buffer for each read operation, and then copy a portion of
> the buffer to the user space buffer.  This can cause a couple of
> issues such as a slow memory allocation, high cpu usage, and a
> corruption of the output data.
> 
> To address these issues, make saved_cmdlines use seq_read.

I changed the subject and change log to the following. The patch is
untouched:

    tracing: Have saved_cmdlines use the seq_read infrastructure
    
    Current tracing_saved_cmdlines_read() implementation is naive; It
    allocates a large buffer, constructs output data to that buffer for
    each read operation, and then copies a portion of the buffer to the
    user space buffer. This has several issues such as slow memory
    allocation, high CPU usage, and even corruption of the output data.
    
    The seq_read infrastructure is made to handle this type of work.
    By converting it to use seq_read() the code becomes smaller,
    simplified, as well as correct.


-- Steve
