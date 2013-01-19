Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3ASK12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:27:28 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55911 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3ASK10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:27:26 -0500
Date: Sat, 19 Jan 2013 11:27:21 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kvm tools: remove redundant "if" condition
Message-ID: <20130119102719.GA12013@gmail.com>
References: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
 <20130116113522.GR11529@redhat.com>
 <20130116165239.GB18593@gmail.com>
 <CAOJsxLFHhKLxNcjwUO-tFrjZ5MYFhWdgBX-LHSkh28-SX1cE4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFHhKLxNcjwUO-tFrjZ5MYFhWdgBX-LHSkh28-SX1cE4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 10:58:33AM +0200, Pekka Enberg wrote:
> On Wed, Jan 16, 2013 at 6:52 PM, Cong Ding <dinggnu@gmail.com> wrote:
> > After we check (state.kcount != 0), state.kcount has to be 0 in all the "else"
> > branchs.
> >
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > ---
> >  tools/kvm/hw/i8042.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/kvm/hw/i8042.c b/tools/kvm/hw/i8042.c
> > index 9f8be6a..9035732 100644
> > --- a/tools/kvm/hw/i8042.c
> > +++ b/tools/kvm/hw/i8042.c
> > @@ -189,7 +189,7 @@ static u32 kbd_read_data(void)
> >                 state.mcount--;
> >                 kvm__irq_line(state.kvm, AUX_IRQ, 0);
> >                 kbd_update_irq();
> > -       } else if (state.kcount == 0) {
> > +       } else {
> >                 i = state.kread - 1;
> >                 if (i < 0)
> >                         i = QUEUE_SIZE;
> 
> This doesn't look right. The 'kcount' field is an int so the value can
> be negative.
But the former check is "state.kcount != 0" as I described in the commit
message. Notice the difference between variable names in the "if" condition: the
first one is kcount, the second one is mcount, and the third one is same as the
first one kcount.

Ok, the original code is
	if (state.kcount != 0) {
		/* do something when (state.kcount != 0) */
	} else if (state.mcount > 0) {
		/* do something when (state.kcount == 0 && state.mount > 0) */
	} else if (state.kcount == 0) {
		/* do something when (state.kcount == 0 && state.mount <= 0) */
	}
For the third branch, it runs when state.kcount == 0 and state.mount <= 0,
it's not necessary to ensure state.kcount == 0 again.

- cong

