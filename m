Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3JCGZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:25:10 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:36888 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3JCGZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:25:08 -0400
Date: Thu, 3 Oct 2013 08:25:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [QUERY] Why does perf-trace need me to be root?
Message-ID: <20131003062505.GE25345@gmail.com>
References: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
 <524C1964.8090205@gmail.com>
 <CALkWK0kzXnBKiRyN5HPE-_nScOG-JKjAnD1ujxA_R8tWQWrxZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0kzXnBKiRyN5HPE-_nScOG-JKjAnD1ujxA_R8tWQWrxZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> David Ahern wrote:
> > If you trust your users make the debugfs mount point rx by group,world.
> 
> Thanks David. I can preserve this configuration across reboots by
> putting an entry in fstab, right? How do I preserve the value of
> /proc/sys/kernel/perf_event_paranoid across reboots?

via:

   echo 'kernel.perf_event_paranoid = -1' >> /etc/sysctl.conf

I think 'perf trace' should probably print such suggestions when it 
notices a privilege problem, to make it far more obvious for new users to 
correctly configure their system for easy tracing.

The current output:

  comet:~/tip> perf trace
  Couldn't read the raw_syscalls tracepoints information!

is as hostile to the user as it gets ;-)

Thanks,

	Ingo
