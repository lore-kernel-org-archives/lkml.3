Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaKLLyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:54:05 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:49854 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbaKLLyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:54:03 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] n_tty: Fix read_buf race condition, increment read_head after pushing data
References: <a2e126c9-3001-4255-91c9-6311b54988c5@EXC02-ATKLA.omicron.at>
	<yw1x4mu5j3c3.fsf@unicorn.mansr.com>
	<CABkLObqGP2488XYCATKE_U-uDjo=tWgEAaU2+YkwstDTnoeetA@mail.gmail.com>
Date: Wed, 12 Nov 2014 11:53:59 +0000
In-Reply-To: <CABkLObqGP2488XYCATKE_U-uDjo=tWgEAaU2+YkwstDTnoeetA@mail.gmail.com>
	(Christian Riesch's message of "Wed, 12 Nov 2014 08:28:56 +0100")
Message-ID: <yw1x1tp8hbxk.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Riesch <christian.riesch@omicron.at> writes:

> On Tue, Nov 11, 2014 at 2:04 PM, Måns Rullgård <mans@mansr.com> wrote:
>> Christian Riesch <christian.riesch@omicron.at> writes:
> [...]>> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
>>> index 2e900a9..b09f326 100644
>>> --- a/drivers/tty/n_tty.c
>>> +++ b/drivers/tty/n_tty.c
>>> @@ -321,7 +321,9 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
>>>
>>>  static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
>>>  {
>>> -     *read_buf_addr(ldata, ldata->read_head++) = c;
>>> +     *read_buf_addr(ldata, ldata->read_head) = c;
>>> +     /* increment read_head _after_ placing the character in the buffer */
>>> +     ldata->read_head++;
>>>  }
>>
>> Is that comment really necessary?
>
> No, I am pretty sure that removing the comment would not break the code ;-)
>
> I just thought it would be good to have some kind of reminder here.
> Otherwise someone may think: Hey, it would be a good idea to do the
> increment right in the first line. And submit a patch for it.

The intent all along was to increment after the write.  Nobody needs
reminding of that.  The problem was a misunderstanding of when the
post-increment takes effect.  As much as we'd like for everybody to have
a thorough knowledge of C, a random tty driver doesn't seem the place to
educate them.

-- 
Måns Rullgård
mans@mansr.com
