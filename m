Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaDGTYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbaDGTYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:24:07 -0400
Date: Mon, 7 Apr 2014 21:24:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ptrace: Fix fork event messages across pid
	namespaces
Message-ID: <20140407192419.GB24607@redhat.com>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com> <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <20140402145850.GB7332@redhat.com> <CAF52+S6vqK_D7bAz9o65ATSZsg4MfqJgo+Qji8+4=OQJDSEJ7A@mail.gmail.com> <CAF52+S4hs2oM_qw9Zo-6qiOp_-Cyt3ZpL+zU2_MUv=d7UKPqEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF52+S4hs2oM_qw9Zo-6qiOp_-Cyt3ZpL+zU2_MUv=d7UKPqEA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Matthew Dempsky wrote:
>
> On Wed, Apr 2, 2014 at 2:58 PM, Matthew Dempsky <mdempsky@google.com> wrote:
> > Otherwise, it looks like (e.g.) the attempts to get the parent's pid
> > in fill_prstatus() and tomoyo_sys_getppid() are also theoretical races
> > of the same kind?
>
> Doh, nevermind, those functions would potentially be use null "struct
> pid" pointers, not "struct pid_namespace" pointers; and pid_nr_ns()
> guards against pid being null.

Yes, and they want the parent's pid, not ours pid in parent's namespace.

Hmm. In fact I am replying only because I am not sure fill_psinfo() is
correct, perhaps it confuses tid with tgid. I dunno.

Oleg.

