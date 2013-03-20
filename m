Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3CTU5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:57:05 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:33272 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3CTU5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:57:03 -0400
Message-ID: <1363813022.31240.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Date: Wed, 20 Mar 2013 13:57:02 -0700
In-Reply-To: <CA+55aFyv3u4uuAamCONMBUmB+rh0JsY4HdOj+UKwtTk0Wzf7Ag@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <CA+55aFyv3u4uuAamCONMBUmB+rh0JsY4HdOj+UKwtTk0Wzf7Ag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 13:49 -0700, Linus Torvalds wrote:
> On Wed, Mar 20, 2013 at 12:55 PM, Rik van Riel <riel@surriel.com> wrote:
> >
> > This series makes the sysv semaphore code more scalable,
> > by reducing the time the semaphore lock is held, and making
> > the locking more scalable for semaphore arrays with multiple
> > semaphores.
> 
> The series looks sane to me, and I like how each individual step is
> pretty small and makes sense.
> 
> It *would* be lovely to see this run with the actual Swingbench
> numbers. The microbenchmark always looked much nicer. Do the
> additional multi-semaphore scalability patches on top of Davidlohr's
> patches help with the swingbench issue, or are we still totally
> swamped by the ipc lock there?

Yes, I'm testing this patchset with my swingbench workloads. I should
have some numbers by today or tomorrow.

> 
> Maybe there were already numbers for that, but the last swingbench
> numbers I can actually recall was from before the finer-grained
> locking..

Right, I couldn't get Oracle to run on the with the previous patches,
hopefully the bug(s) are now addressed.

Thanks,
Davidlohr

