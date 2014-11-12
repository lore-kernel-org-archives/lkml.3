Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaKLH3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:29:00 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34993 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaKLH26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:28:58 -0500
MIME-Version: 1.0
In-Reply-To: <yw1x4mu5j3c3.fsf@unicorn.mansr.com>
References: <a2e126c9-3001-4255-91c9-6311b54988c5@EXC02-ATKLA.omicron.at>
	<yw1x4mu5j3c3.fsf@unicorn.mansr.com>
Date: Wed, 12 Nov 2014 08:28:56 +0100
X-Google-Sender-Auth: VyB46Ud0ykbKPpVTKsiT5ZvNEcc
Message-ID: <CABkLObqGP2488XYCATKE_U-uDjo=tWgEAaU2+YkwstDTnoeetA@mail.gmail.com>
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

On Tue, Nov 11, 2014 at 2:04 PM, Måns Rullgård <mans@mansr.com> wrote:
> Christian Riesch <christian.riesch@omicron.at> writes:
[...]>> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
>> index 2e900a9..b09f326 100644
>> --- a/drivers/tty/n_tty.c
>> +++ b/drivers/tty/n_tty.c
>> @@ -321,7 +321,9 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
>>
>>  static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
>>  {
>> -     *read_buf_addr(ldata, ldata->read_head++) = c;
>> +     *read_buf_addr(ldata, ldata->read_head) = c;
>> +     /* increment read_head _after_ placing the character in the buffer */
>> +     ldata->read_head++;
>>  }
>
> Is that comment really necessary?

No, I am pretty sure that removing the comment would not break the code ;-)

I just thought it would be good to have some kind of reminder here.
Otherwise someone may think: Hey, it would be a good idea to do the
increment right in the first line. And submit a patch for it.
But I am also ok with removing the comment. So if you like me to post
a v3 without the comment, I'll be happy to do that.

Christian
