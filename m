Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaEIKR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:17:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57395 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaEIKR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:17:26 -0400
Date: Fri, 9 May 2014 12:17:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140509101722.GB16260@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
 <20140506185826.GF25013@pd.tnic>
 <20140507170155.GH32718@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140507170155.GH32718@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 07:01:55PM +0200, Robert Richter wrote:
> I am fine with a fixed size. But this design might not be changable in
> the future without breaking the API. So its worth to think about this.
> Maybe we allow the process also to create the buffer, there are 2
> variants then:
> 
>  perf_event_open(...);
>  mmap(..., fd, ...);
>  ioctl(fd, set_persistent, 1);   /* Use existing buffer. */
>  close();
> 
>  fd = perf_event_open(...);
>  ioctl(fd, set_persistent, 1);   /* Create buffer with default size. */
>  close();
> 
> This would solve the problem how we adjust buffer size.
> 
> This requires a way to detect buffer size. See my mail how this could
> be done.

Yep, this makes sense and fits nicely with the perf interface so
persistent buffer sizes will be established at event creation.

This is all fine then.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
