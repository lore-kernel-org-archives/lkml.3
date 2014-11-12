Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaKLUDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:03:19 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43979 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaKLUDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:03:18 -0500
MIME-Version: 1.0
In-Reply-To: <yw1x1tp8hbxk.fsf@unicorn.mansr.com>
References: <a2e126c9-3001-4255-91c9-6311b54988c5@EXC02-ATKLA.omicron.at>
	<yw1x4mu5j3c3.fsf@unicorn.mansr.com>
	<CABkLObqGP2488XYCATKE_U-uDjo=tWgEAaU2+YkwstDTnoeetA@mail.gmail.com>
	<yw1x1tp8hbxk.fsf@unicorn.mansr.com>
Date: Wed, 12 Nov 2014 21:03:16 +0100
X-Google-Sender-Auth: 6QVqUiJ5X-F_WYLrYp1pyo0jRhg
Message-ID: <CABkLOboD+sEtPgft2Gpm6EGfVHzdkyUORntqjNBkCLSPH3Mb8w@mail.gmail.com>
Subject: Re: [PATCH v2] n_tty: Fix read_buf race condition, increment
 read_head after pushing data
From: Christian Riesch <christian.riesch@omicron.at>
To: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 12:53 PM, Måns Rullgård <mans@mansr.com> wrote:
> Christian Riesch <christian.riesch@omicron.at> writes:
>
>> On Tue, Nov 11, 2014 at 2:04 PM, Måns Rullgård <mans@mansr.com> wrote:
>>> Christian Riesch <christian.riesch@omicron.at> writes:
>> [...]>> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
>>>> index 2e900a9..b09f326 100644
>>>> --- a/drivers/tty/n_tty.c
>>>> +++ b/drivers/tty/n_tty.c
>>>> @@ -321,7 +321,9 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
>>>>
>>>>  static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
>>>>  {
>>>> -     *read_buf_addr(ldata, ldata->read_head++) = c;
>>>> +     *read_buf_addr(ldata, ldata->read_head) = c;
>>>> +     /* increment read_head _after_ placing the character in the buffer */
>>>> +     ldata->read_head++;
>>>>  }
>>>
>>> Is that comment really necessary?
>>
>> No, I am pretty sure that removing the comment would not break the code ;-)
>>
>> I just thought it would be good to have some kind of reminder here.
>> Otherwise someone may think: Hey, it would be a good idea to do the
>> increment right in the first line. And submit a patch for it.
>
> The intent all along was to increment after the write.  Nobody needs
> reminding of that.  The problem was a misunderstanding of when the
> post-increment takes effect.  As much as we'd like for everybody to have
> a thorough knowledge of C, a random tty driver doesn't seem the place to
> educate them.

Ok. I will send a new patch without the comment.
Thanks, Christian
