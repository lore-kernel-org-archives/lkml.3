Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaEIIxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:53:00 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56810 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaEIIw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:52:57 -0400
Date: Fri, 9 May 2014 10:52:52 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140509085252.GS32718@rric.localhost>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
 <20140506185826.GF25013@pd.tnic>
 <20140507170155.GH32718@rric.localhost>
 <20140508183629.GJ12548@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508183629.GJ12548@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.14 20:36:29, Borislav Petkov wrote:
> On Wed, May 07, 2014 at 07:01:55PM +0200, Robert Richter wrote:
> > For general-purpose... Why 512k buffers are ok? Depending on the
> > event, smaller buffers are maybe good enough, esp. since they are
> > permanently enabled and use system resources. Or, at some point, 512k
> > is not sufficient anymore. You don't want 512k be carved in stone.
> 
> Well, if it turns out that 512K is not enough, it will be changed in
> perf itself, right?

This requires patching the kernel.

> 
> And we still don't care because no matter the size, the persistent
> buffers overwrite themselves on fill up. If they'd stopped, they're not
> really persistent, right?

If the buffer size does not fit it might either use too much resources
in the system or overwrite its own samples before reading it.

Fixed buffers might work and are good enough in the beginning. If all
users can live with it, fine. But if not, the design does not allow
changes in API without breaking it. What's that I care about and
what's we should think about while designing the i/f.

-Robert
