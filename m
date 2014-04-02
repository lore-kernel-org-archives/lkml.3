Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027AbaDBWh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:37:57 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:54283 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030655AbaDBWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAF52+S6vqK_D7bAz9o65ATSZsg4MfqJgo+Qji8+4=OQJDSEJ7A@mail.gmail.com>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com>
 <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <20140402145850.GB7332@redhat.com>
 <CAF52+S6vqK_D7bAz9o65ATSZsg4MfqJgo+Qji8+4=OQJDSEJ7A@mail.gmail.com>
From: Matthew Dempsky <mdempsky@chromium.org>
Date: Wed, 2 Apr 2014 15:37:33 -0700
X-Google-Sender-Auth: _hmdykTf5jUWzGCUPR2WLDVfeeU
Message-ID: <CAF52+S4hs2oM_qw9Zo-6qiOp_-Cyt3ZpL+zU2_MUv=d7UKPqEA@mail.gmail.com>
Subject: Re: [PATCH v3] ptrace: Fix fork event messages across pid namespaces
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 2:58 PM, Matthew Dempsky <mdempsky@google.com> wrote:
> Otherwise, it looks like (e.g.) the attempts to get the parent's pid
> in fill_prstatus() and tomoyo_sys_getppid() are also theoretical races
> of the same kind?

Doh, nevermind, those functions would potentially be use null "struct
pid" pointers, not "struct pid_namespace" pointers; and pid_nr_ns()
guards against pid being null.

Okay, I think I understand now why guarding against the
task_parent_pid_ns() here is consistent with other RCU code.  I'll
send a revised patch that does that.

Also, it looks like "0" is the conventional value for unrepresentable
pid_t values, so I'll change to do that too.
