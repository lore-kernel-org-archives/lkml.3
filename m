Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaDBQpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:45:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaDBQpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:45:34 -0400
Date: Wed, 2 Apr 2014 17:44:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] pid_namespace: pidns_get() should check
	task_active_pid_ns() != NULL
Message-ID: <20140402154447.GA29857@redhat.com>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com> <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <20140402145850.GB7332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402145850.GB7332@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Oleg Nesterov wrote:
>
> Especially because this code needs a fix. Yes, rcu_read_lock() should
> be enough to ensure that ->parent and its namespace (if !NULL) can not
> go away, but task_active_pid_ns() can return NULL release_task(->parent)
> was already (although this race is pure theoretical). So this helper
> should also check it is !NULL under rcu_read_lock(), afaics.
>
> (Hmm... off-topic, but get_pidns looks buggy by the same reason, I'll
>  send a fix).

Eric, I have to admit that I din't bother to actually verify this, but
pidns_get() looks "obviously buggy". Could you ack/nack ?

Oleg.

