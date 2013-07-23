Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab3GWQsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764Ab3GWQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:48:09 -0400
Date: Tue, 23 Jul 2013 18:43:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ptrace(PTRACE_ATTACH)  [no intervering wait]
	ptrace(PTRACE_DETACH) may leave tracee stuck
Message-ID: <20130723164305.GA28460@redhat.com>
References: <1374573914.30532.68.camel@marge.simpson.net> <20130723155854.GA26211@redhat.com> <20130723163806.GA27905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723163806.GA27905@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn. Sorry for noise Mike,

On 07/23, Oleg Nesterov wrote:
>
> OTOH, in this particular case pldd.c doesn't really need PTRACE_DETACH,
> it can simply exit.

No it can't, I forgot that exit_ptrace() doesn't (and can't) clear
->exit_code. And this is another reason why PTRACE_DETACH needs the
stopped tracee.

Oleg.

