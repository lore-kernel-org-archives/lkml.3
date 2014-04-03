Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaDCQNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaDCQNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:13:15 -0400
Date: Thu, 3 Apr 2014 18:13:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ptrace: Fix fork event messages across pid
	namespaces
Message-ID: <20140403161329.GA17892@redhat.com>
References: <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <1396492005-23811-1-git-send-email-mdempsky@chromium.org> <20140403154413.GA16684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403154413.GA16684@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Oleg Nesterov wrote:
>
> Some notes for potential future changes...
>
> 	- I do not not see any potential user of ptrace_event_pid() outside
> 	  of fork.c, so perhaps this helper should not be exported.
>
> 	  In fact I wouldn't mind if you send v5 which moves it into fork.c ;)

OTOH, exec_binprm() can use it... although in this case it needs get/put_pid
too. So please ignore.

Oleg.

