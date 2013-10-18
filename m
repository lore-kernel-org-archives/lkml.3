Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3JRCT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 22:19:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:48151 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755178Ab3JRCT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 22:19:57 -0400
Date: Thu, 17 Oct 2013 22:19:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 2/5] trace-cmd: Apply the trace-msg protocol for
 communication between a server and clients
Message-ID: <20131017221953.4bc6d43e@gandalf.local.home>
In-Reply-To: <20130913020632.28927.18549.stgit@yunodevel>
References: <20130913020627.28927.69090.stgit@yunodevel>
	<20130913020632.28927.18549.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013 11:06:32 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:


> diff --git a/trace-msg.c b/trace-msg.c
> new file mode 100644
> index 0000000..cf82ff6
> --- /dev/null
> +++ b/trace-msg.c
> @@ -0,0 +1,683 @@
> +/*
> + * trace-msg.c : define message protocol for communication between clients and
> + *               a server
> + *
> + * Copyright (C) 2013 Hitachi, Ltd.
> + * Created by Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License (not later!)
> + *

BTW, as this can be used in a library, would be OK with re-licensing
this as the LGPL v2.1?

I try to keep all the helper C files as LGPL and the program files as
GPL. I would have made all of trace-cmd LGPL, but there was some code I
needed that was GPL, and I could only use it if I had the program as
GPL code.

-- Steve


> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not,  see <http://www.gnu.org/licenses>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
