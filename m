Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3AaAb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:31:27 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:43554 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AaAbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:31:25 -0500
MIME-Version: 1.0
In-Reply-To: <CANN689HUyc4WyM5irQ6ru+80tf=Fk53QH3ynNJFSTg2ig3dk9A@mail.gmail.com>
References: <1357145418.5429.17.camel@mesosphere.localdomain>
	<CANN689HqKWf2SdE+HHQum9ukpwj6HbQoh66fZciWZuQVaJaUxQ@mail.gmail.com>
	<1357232977.1886.17.camel@mesosphere.localdomain>
	<20130104115748.GA8830@google.com>
	<1357368032.1927.5.camel@mesosphere.localdomain>
	<CANN689HUyc4WyM5irQ6ru+80tf=Fk53QH3ynNJFSTg2ig3dk9A@mail.gmail.com>
Date: Wed, 30 Jan 2013 16:31:23 -0800
Message-ID: <CANN689G7KgUFQLNnukfHL5JSW-Zu=WuzVbyhYBJUxEsUUyDHMQ@mail.gmail.com>
Subject: Re: mmap() scalability in the presence of the MAP_POPULATE flag
From: Michel Lespinasse <walken@google.com>
To: Roman Dubtsov <dubtsov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

On Fri, Jan 4, 2013 at 11:43 PM, Michel Lespinasse <walken@google.com> wrote:
> On Fri, Jan 4, 2013 at 10:40 PM, Roman Dubtsov <dubtsov@gmail.com> wrote:
>> - POPULATE_VIA_LOOP -- makes the test populate memory using a loop
>> - POPULATE_VIA_MMAP -- makes the test populate memory via MAP_POPULATE
>>
> Heh, very interesting. As it turns out, the problem gets MUCH worse as
> the number of threads increase.
>
> In the POPULATE_VIA_MMAP, follow_page() is called at 4KB increment
> addresses, and it takes the mm->page_table_lock 511 times out of 512
> (that is, every time it falls within a huge page that's just been
> populated). So all OMP_NUM_THREADS threads are constantly bouncing
> over the mm->page_table_lock, and getting terrible performance as a
> result.

FYI, the patchset I just sent out ("fixes for large mm_populate() and
munlock() operations") takes care of this and brings POPULATE_VIA_MMAP
performance up where it should be.

Thanks a lot for the report, as I hadn't noticed this issue before :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
