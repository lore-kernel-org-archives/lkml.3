Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3GAL0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:26:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51375 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3GAL0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:26:05 -0400
Message-ID: <51D16748.3020705@hitachi.com>
Date: Mon, 01 Jul 2013 20:26:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/11] tracing: add soft disable for syscall events
References: <cover.1372479499.git.tom.zanussi@linux.intel.com> <d7a32766817e9050997629b195676e357e410726.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <d7a32766817e9050997629b195676e357e410726.1372479499.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

(2013/06/29 14:08), Tom Zanussi wrote:
> Add support for SOFT_DISABLE to syscall events.
> 
> The original SOFT_DISABLE patches didn't add support for soft disable
> of syscall events; this adds it and paves the way for future patches
> allowing triggers to be added to syscall events, since triggers are
> built on top of SOFT_DISABLE.
> 
> The existing code grabs the trace_array from the ftrace_file passed to
> the event registration functions and passes that to the probe
> functions.  Passing the file instead allows the probe functions to
> access not only the trace_array attached to the file but the flags as
> well.

Hmm, this is not so simple. Syscall trace events are special events which
uses refcount and bitmap to identify syscall metadata, and only the first
enable request is passed for registering event handler.
Perhaps, we need to introduce a soft-disabled bitmap for tr or soft-disabled
bitflag for each syscall metadata.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


