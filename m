Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaIVVd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:33:56 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:55961 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaIVVdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:33:54 -0400
Date: Tue, 23 Sep 2014 00:33:45 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <michaele@au1.ibm.com>,
        linuxppc-dev@ozlabs.org, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>, ulrich.weigand@de.ibm.com,
        Maynard Johnson <mpjohn@us.ibm.com>
Subject: Re: [PATCH v5 1/1] powerpc/perf: Adjust callchain based on DWARF
 debug info
Message-ID: <20140922213345.GB666@drone.musicnaut.iki.fi>
References: <20140625000052.GA4484@us.ibm.com>
 <20140625074248.GC1153@krava.brq.redhat.com>
 <20140625154903.GA29607@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625154903.GA29607@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 25, 2014 at 08:49:03AM -0700, Sukadev Bhattiprolu wrote:
> powerpc/perf: Adjust callchain based on DWARF debug info
> 
> When saving the callchain on Power, the kernel conservatively saves excess
> entries in the callchain. A few of these entries are needed in some cases
> but not others. We should use the DWARF debug information to determine
> when the entries are  needed.

This patch breaks perf compilation if DWARF support is not present.
DWARF support is auto-detected early in the build, so IMHO either user
should be informed to install the needed stuff, or the build should
succeed with limited functionality.

arch/powerpc/util/skip-callchain-idx.c:13:19: fatal error: dwarf.h: No such file or directory #include <dwarf.h>
                   ^
compilation terminated.

A.
