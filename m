Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaEUVx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:53:29 -0400
Received: from smtp.bbn.com ([128.33.1.81]:10134 "EHLO smtp.bbn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaEUVx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:53:27 -0400
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 17:53:27 EDT
X-Submitted: to socket.bbn.com (Postfix) with ESMTPSA id 8349340320
Message-ID: <537D1B05.6030209@bbn.com>
Date: Wed, 21 May 2014 17:30:45 -0400
From: Richard Hansen <rhansen@bbn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.0.0-rc4
References: <xmqqr43oq8q5.fsf@gitster.dls.corp.google.com>
In-Reply-To: <xmqqr43oq8q5.fsf@gitster.dls.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-20 20:24, Junio C Hamano wrote:
> Fixes since v1.9 series
> -----------------------
> 
> Unless otherwise noted, all the fixes since v1.9 in the maintenance
> track are contained in this release (see the maintenance releases'
> notes for details).
[...]
>
>  * The shell prompt script (in contrib/), when using the PROMPT_COMMAND
>    interface, used an unsafe construct when showing the branch name in
>    $PS1.
>    (merge 8976500 rh/prompt-pcmode-avoid-eval-on-refname later to maint).

That commit has been merged to maint and is in v1.9.3.

Also, 1e4119c (git-prompt.sh: don't assume the shell expands the value
of PS1) is a fix that is in v2.0.0-rc4 but not v1.9.x.  Maybe add
something like:

 * The shell prompt script (in contrib/), when using Zsh and the
   precmd() interface, printed ${__git_ps1_branch_name} in the prompt
   instead of the branch name (regression in v1.9.3).
   (merge 1e4119c rh/prompt-pcmode-avoid-eval-on-refname later to
   maint).

-Richard
