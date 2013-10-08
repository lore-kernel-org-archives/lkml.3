Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3JHODN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab3JHODH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:03:07 -0400
Date: Tue, 8 Oct 2013 16:02:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V5 3/9] perf tools: workaround objdump difficulties with
 kcore
Message-ID: <20131008140236.GD1348@krava.redhat.com>
References: <1381221956-16699-1-git-send-email-adrian.hunter@intel.com>
 <1381221956-16699-4-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381221956-16699-4-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:45:50AM +0300, Adrian Hunter wrote:
> objdump fails to annotate module symbols when looking
> at kcore.  Workaround this by extracting object code
> from kcore and putting it in a temporary file for
> objdump to use instead.  The temporary file is created
> to look like kcore but contains only the function
> being disassembled.

Excited to ses this one, but looks like I'm hitting some
issue.  All annotation starts for me like this:

                                                                                                       ▒
       │              Disassembly of section load0:                                                            ▒
       │                                                                                                       ▒
       │              ffffffff815eee80 <load0>:                                                                ◆
  9.33 │ffffffff815eee80:   data32 data32 data32 xchg %ax,%ax                                                  


which does not seem right

thanks,
jirka
