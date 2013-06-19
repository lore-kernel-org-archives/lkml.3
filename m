Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883Ab3FSQ5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934462Ab3FSQ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:57:14 -0400
Date: Wed, 19 Jun 2013 18:52:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] ptrace: make PTRACE_DETACH work on non-stopped tracees.
Message-ID: <20130619165259.GA16002@redhat.com>
References: <1371654936-31742-1-git-send-email-dvlasenk@redhat.com> <20130619160930.GA15631@host2.jankratochvil.net> <51C1DF77.5030006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C1DF77.5030006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Pedro Alves wrote:
>
> On 06/19/2013 05:09 PM, Jan Kratochvil wrote:
> > On Wed, 19 Jun 2013 17:15:36 +0200, Denys Vlasenko wrote:
> >> CCing Jan to hear his comments from gdb side.
>
> PTRACE_DETACH takes a signal number in the data parameter.
> What happens to if the tracer passes a non-zero signal?

non-zero doesn't matter, zero is equally bad.

ptrace_detach() simply does child->exit_code = data, assuming
that child will look at it after resume. This is just wrong if
the child is not stopped.

Oleg.

