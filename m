Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaAOTkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:40:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32455 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751618AbaAOTkm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:40:42 -0500
Date: Wed, 15 Jan 2014 14:40:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/3] tools lib traceevent: fix pointer-integer size
 mismatch
Message-ID: <20140115144039.6648985a@gandalf.local.home>
In-Reply-To: <20140115181406.GB9750@ghostprotocols.net>
References: <1389782648-4417-1-git-send-email-mark.rutland@arm.com>
	<1389782648-4417-3-git-send-email-mark.rutland@arm.com>
	<20140115181406.GB9750@ghostprotocols.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 15:14:06 -0300
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Wed, Jan 15, 2014 at 10:44:07AM +0000, Mark Rutland escreveu:
> > The scsi and cfg80211 plugins cast between unsigned long long and
> > pointers, which is problematic for architectures where unsigned long
> > long is wider than the native pointer size:
> > 
> >   linux/tools/lib/traceevent/plugin_scsi.c: In function ‘process_scsi_trace_parse_cdb’:
> >   linux/tools/lib/traceevent/plugin_scsi.c:408:26: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >     scsi_trace_parse_cdb(s, (unsigned char *) args[1], args[2]);
> > 
> >   linux/tools/lib/traceevent/plugin_cfg80211.c: In function ‘process___le16_to_cpup’:
> >   linux/tools/lib/traceevent/plugin_cfg80211.c:11:18: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >     uint16_t *val = (uint16_t *) args[0];
> > 
> > This patch adds an intermediate cast to unsigned long, silencing the
> > warning.
> 
> Steven, Jiri: Acked-by?

Yep, that's the correct solution.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>

