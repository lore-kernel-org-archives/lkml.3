Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaDPQvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:51:00 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:47609 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaDPQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:50:57 -0400
Date: Wed, 16 Apr 2014 12:50:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
Message-ID: <20140416165052.GK1257@htj.dyndns.org>
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com>
 <5335661E.7030408@cn.fujitsu.com>
 <20140415164752.GC30990@htj.dyndns.org>
 <534DDBFC.9060803@cn.fujitsu.com>
 <20140416152326.GG1257@htj.dyndns.org>
 <CACvQF532wtmegbNixch2zTGDmYoGoB4TFTHikw3dTNQPo7Gg2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF532wtmegbNixch2zTGDmYoGoB4TFTHikw3dTNQPo7Gg2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Apr 17, 2014 at 12:21:21AM +0800, Lai Jiangshan wrote:
> OK. It is better to use get_pwq(). I will also change the above comments to:
> 
>   The base ref and the possible ref from rerscuer(stopped) are never
> dropped on per-cpu pwqs.
>   Directly free the pwqs and wq.

Hmmm, why does that matter?  The base ref is the business of
create/destroy path and as long as base ref is never put other refs
just don't matter.

> The reason I quickly dropped V1 and wrote the V2 is that I saw this comment.
> "The base ref" is precise after I used get_pwq() in V1.
> 
> Or to avoid to change to this comments.
> I can also move the following code down to the bottom of the rescuer_thread().
> 
> if (kthread_should_stop()) {
> __set_current_state(TASK_RUNNING);
> rescuer->task->flags &= ~PF_WQ_WORKER;
> return 0;
> }
> 
> (I reply this email on browser, never mind the syntax).
> Maybe the second choice are better.

Hmmm... yeah, regardlesss of the above, it's a bit nasty that rescuer
may exit with non-empty mayday list.

Thanks.

-- 
tejun
