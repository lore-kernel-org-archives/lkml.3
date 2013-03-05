Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3CESHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:07:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758719Ab3CESHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:07:36 -0500
Date: Tue, 5 Mar 2013 19:05:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
Message-ID: <20130305180542.GA12738@redhat.com>
References: <201303042055.38040.maciej.rutecki@gmail.com> <1362504883-9180-1-git-send-email-msb@chromium.org> <20130305174838.GA7276@redhat.com> <CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Mandeep Singh Baines wrote:
>
> On Tue, Mar 5, 2013 at 9:48 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 03/05, Mandeep Singh Baines wrote:
> >>
> >> @@ -2462,13 +2462,13 @@ static int hotkey_kthread(void *data)
> >>       unsigned int poll_freq;
> >>       bool was_frozen;
> >>
> >> +     set_freezable();
> >> +
> >>       mutex_lock(&hotkey_thread_mutex);
> >>
> >>       if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
> >>               goto exit;
> >>
> >> -     set_freezable();
> >> -
> >
> > I don't understand this code... but don't we have the same problem
> > with kthread_freezable_should_stop() below? It can call __refrigerator()
> > too under the same lock.
> >
>
> I don't think the lock is held at that point. There is an unlock right
> before entering the while loop and at the bottom of the loop.

Hmm... Afaics this is another lock, hotkey_thread_data_mutex. But
hotkey_thread_mutex is still held.

Oleg.

