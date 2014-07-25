Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbaGYIPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:15:38 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:36925 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759680AbaGYIPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140725064836.GE2397@laptop.redhat.com>
References: <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
	<CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
	<20140723182518.GD3935@laptop>
	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
	<20140723184111.GG3935@laptop>
	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
	<20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<20140725064836.GE2397@laptop.redhat.com>
Date: Fri, 25 Jul 2014 01:15:31 -0700
X-Google-Sender-Auth: 2yqrxPEy3C53vd5TopV5kyKFfOg
Message-ID: <CA+55aFyrNZ1EHyjfi6VCLHtERCqqL2b=CwZ542nR_xBYouvmfw@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:48 PM, Jakub Jelinek <jakub@redhat.com> wrote:
>
> Can I ask anyone involved in this for preprocessed source and all gcc command
> line options to reproduce it, best in the form of a http://gcc.gnu.org/bugzilla/
> bugreport?

I've created bug 61904 for this:

  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61904

Note that I don't personally have a reproducer (my machine has
gcc-4.8.3, and I don't see the same behavior), but I included the
incorrect fair.s file that Michel sent me (which has all the command
line options in it), and a pre-processed "fair.i" source file that I
generated and that *should* match the configuration that was the
source for that result. So there might be some version/configuration
skew there between the two files, but I think they match.

Holler if you cannot reproduce the problem based on that.

            Linus
