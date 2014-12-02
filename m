Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbaLBVbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:31:09 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52747 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaLBVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:31:08 -0500
Date: Tue, 2 Dec 2014 13:31:04 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: Fix sign bug in ntp mult overflow warning
Message-ID: <20141202213104.GA14149@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Xunlei Pang <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org
References: <20141122184506.GC29361@wfg-t540p.sh.intel.com>
 <1416890145-30048-1-git-send-email-john.stultz@linaro.org>
 <20141202093228.GA8792@hudson.localdomain>
 <CADcy93Wf9q1hyL43UwVjfCrWyn_PHSHJgLnzHvianjkxUxr2Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADcy93Wf9q1hyL43UwVjfCrWyn_PHSHJgLnzHvianjkxUxr2Sg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xunlei,

On Tue, Dec 02, 2014 at 11:00:26PM +0800, Xunlei Pang wrote:
> On 2 December 2014 at 17:32, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> > John,
> >
> > On Mon, Nov 24, 2014 at 08:35:45PM -0800, John Stultz wrote:
> >> In commit 6067dc5a8c2b ("time: Avoid possible NTP adjustment mult
> >> @@ -1330,7 +1330,7 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
[...]
> >>        *
> >>        * XXX - TODO: Doc ntp_error calculation.
> >>        */
> >> -     if (tk->tkr.mult + mult_adj < mult_adj) {
> >> +     if ((mult_adj > 0) && (tk->tkr.mult + mult_adj < mult_adj)) {
> >>               /* NTP adjustment caused clocksource mult overflow */
> >>               WARN_ON_ONCE(1);
> >>               return;
> >
> > This change does quiet the warning but I think it does so for the wrong
> > reason.
> >
> > mult_adj is a signed number and tk->tkr.mult is an unsigned number.
> > Adding the check that (mult_adj > 0) limits the test to only positive
> > numbers.  A positive number plus a positive number will never be less
> > than either of the two positive numbers.  The test is always false.
> 
> Hi Jeremiah,
> 
> The result of a positive number plus a positive number may overflow,
> for example, u32  (0xFFFF_FFF0 + 0x20) will be 0x10,
> that's what this patch is dealing with.
> 
> Thanks,
> Xunlei
> >
> > --
> > - Jeremiah Mahler

Oh, got it.  That makes sense now.  Thanks :)

-- 
- Jeremiah Mahler
