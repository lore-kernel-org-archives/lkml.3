Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaE0ULi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:11:38 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51375 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaE0ULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:11:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff tracers
Date: Tue, 27 May 2014 22:11:25 +0200
Message-ID: <17051981.niWmA6MIgX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OOdp2xTPRBaz5nCX0Tj7XerghhLBqYoQcydTdv9S4nG
 iHEt50cGSvXY/aJJ+42rcf662aBloxMNAwDmYeY/ncXznj6z7+
 c+SK27QhoYtYDazxJnVDtkP8ShmDQ5R0Q4OBD4694RlAfMdrK8
 wKo2Rn7duKTeYm+tu0OcNu8y5dBCs8VIOZCRg1UqXdPEcRM57R
 i8FqDDeIVDjgwpKp/41rAD5Rf5x7o9soFRzgDx+Ora9ZdOXEnW
 m0MAlHHM7gJhZ8Rjp//dUxHQmE1xeiNuMBPoZWDnolB4q3qdXd
 4VRgua958FUff/6w3fFjjSNm/ZOodCcGwVkml9xddX1x/GdKzo
 PtB7KWC2CH+6Pp0Ek13A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 13:08:04 Stephen Boyd wrote:
> @@ -380,7 +382,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
>  
>         cpu = raw_smp_processor_id();
>  
> -       if (per_cpu(tracing_cpu, cpu))
> +       if (per_cpu(timings_stopped, cpu) || per_cpu(tracing_cpu, cpu))
>                 return;
>  
>         data = per_cpu_ptr(tr->trace_buffer.data, cpu);
> 

Where exactly do you see other code calling here while
per_cpu(timings_stopped) is set? Would it be possible to just
change that call site?

	Arnd
