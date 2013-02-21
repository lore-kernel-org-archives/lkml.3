Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab3BUWnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:43:04 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:34185 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab3BUWm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:42:56 -0500
Date: Fri, 22 Feb 2013 02:42:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Steven Rostedt <rostedt@goodmis.org>, u3557@dialix.com.au,
        Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: prctl(PR_SET_MM)
Message-ID: <20130221224252.GO1740@moon>
References: <20130220105109.GW20312@moon>
 <20130221074639.4880D592064@miso.sublimeip.com>
 <20130221080028.GE1740@moon>
 <20130221141841.c760b02f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221141841.c760b02f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 02:18:41PM -0800, Andrew Morton wrote:
> On Thu, 21 Feb 2013 12:00:28 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > From: Amnon Shiloh <u3557@miso.sublimeip.com>
> > Subject: prctl: Make PR_SET_MM being depend on own CONFIG_MM_FIELDS_SETTING
> > 
> > ...
> > 
> > Signed-off-by: Amnon Shiloh <u3557@miso.sublimeip.com>
> 
> The "..." makes me sad.
> 
> If/when this patch gets sent for real, please explain the reasons? 
> AFAICT it permits the enabling of prctl(PR_SET_MM) in
> CONFIG_CHECKPOINT_RESTORE=n kernels.  If that was indeed the intent,
> why?

Sorry for this "...", it was a draft version for Amnon, not for inclusion.
As far as I understand Amnon needs these prctl opcodes to be enabled by
default (but still turnable off in Kconfig if needed) for his minimal
c/r software, he do not need the whole c/r functionality (procfs map-files,
get-tid-address,kcmp and such). That is the idea if I understand correctly.

Quoting Amnon
|
| Correct, this is an important feature that is useful for a whole 
| general class of applications, not only those needing CHECKPOINT_RESTORE. 
|
| Had this not been done as part of the CHECKPOINT_RESTORE project, it 
| would have certainly been done, sooner or later, by some other developers: 
| it just so happened that the CHECKPOINT_RESTORE people were the first to 
| (publically) fill this gap, but in fact this code in "kernel/sys.c" should 
| be general kernel code, not part of CHECKPOINT_RESTORE.
|

I personally don't mind if this code become y by default (it requires
cap-sys-resource capability granted anyway), but for normal c/r this
prctl opcodes only is not enough and CHECKPOINT_RESTORE should be set.
Thus, if people agree with enabling prctl extension by default I certainly
won't object.
