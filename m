Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaIWG7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbaIWG7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:59:34 -0400
Date: Tue, 23 Sep 2014 08:59:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Michael Ellerman <michaele@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        Anton Blanchard <anton@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>, ulrich.weigand@de.ibm.com,
        Maynard Johnson <mpjohn@us.ibm.com>
Subject: Re: [PATCH v5 1/1] powerpc/perf: Adjust callchain based on DWARF
 debug info
Message-ID: <20140923065906.GA2979@krava.brq.redhat.com>
References: <20140625000052.GA4484@us.ibm.com>
 <20140625074248.GC1153@krava.brq.redhat.com>
 <20140625154903.GA29607@us.ibm.com>
 <20140922213345.GB666@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922213345.GB666@drone.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:33:45AM +0300, Aaro Koskinen wrote:
> Hi,
> 
> On Wed, Jun 25, 2014 at 08:49:03AM -0700, Sukadev Bhattiprolu wrote:
> > powerpc/perf: Adjust callchain based on DWARF debug info
> > 
> > When saving the callchain on Power, the kernel conservatively saves excess
> > entries in the callchain. A few of these entries are needed in some cases
> > but not others. We should use the DWARF debug information to determine
> > when the entries are  needed.
> 
> This patch breaks perf compilation if DWARF support is not present.
> DWARF support is auto-detected early in the build, so IMHO either user
> should be informed to install the needed stuff, or the build should
> succeed with limited functionality.
> 
> arch/powerpc/util/skip-callchain-idx.c:13:19: fatal error: dwarf.h: No such file or directory #include <dwarf.h>
>                    ^
> compilation terminated.

looks like powerpc issue.. hows 'make -f tests/make' doing
on powerpc? It tests above scenario.

jirka
