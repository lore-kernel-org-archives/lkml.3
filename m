Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3KKNCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:02:37 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43688 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3KKNCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:02:30 -0500
X-AuditID: 9c93017e-b7cbeae0000003a9-54-5280d563e814
Date: Mon, 11 Nov 2013 22:02:27 +0900
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Matthew Daley <mattjd@gmail.com>, chan.jeong@lge.com, hyojun.im@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unlz4: always set an error return code on failures
Message-ID: <20131111130227.GA31739@hulk>
References: <527CBC7D020000780010117C@nat28.tlf.novell.com>
 <20131111024924.GA23164@hulk>
 <5280A4E30200007800101A2C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5280A4E30200007800101A2C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 08:35:31AM +0000, Jan Beulich wrote:
> >>> On 11.11.13 at 03:49, Kyungsik Lee <kyungsik.lee@lge.com> wrote:
> > Hello Jan,
> > 
> > Thanks for the patch.
> > 
> > On Fri, Nov 08, 2013 at 09:27:09AM +0000, Jan Beulich wrote:
> >> "ret", being set to -1 early on, gets cleared by the first invocation
> >> of lz4_decompress()/lz4_decompress_unknownoutputsize(), and hence
> >> subsequent failures wouldn't be noticed by the caller without setting
> >> it back to -1 right after those calls.
> >> 
> >> Reported-by: Matthew Daley <mattjd@gmail.com>
> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >> Cc: Kyungsik Lee <kyungsik.lee@lge.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> 
> >> --- a/lib/decompress_unlz4.c
> >> +++ b/lib/decompress_unlz4.c
> >> @@ -141,6 +141,7 @@ STATIC inline int INIT unlz4(u8 *input, 
> >>  			goto exit_2;
> >>  		}
> >>  
> >> +		ret = -1;
> >>  		if (flush && flush(outp, dest_len) != dest_len)
> >>  			goto exit_2;
> >>  		if (output)
> >>
> > What do you think of adding "ret2" for keeping "ret" error status
> > which is set by lz4_decompress*() like below.
> 
> I'd be fine with that too, but preferred to submit the smallest
> possible (read: one line) patch in this case.
>
I think it looks neat avoiding "ret" being set to error status
in the loop. Can you please resend the patch with those changes?

Acked-by: Kyungsik Lee <kyungsik.lee@lge.com>

Thanks,
Kyungsik
