Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3KVIW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:22:28 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59184 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3KVIWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:22:22 -0500
Message-ID: <528F143B.5020507@gmail.com>
Date: Fri, 22 Nov 2013 09:22:19 +0100
From: Andreas Platschek <andi.platschek@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: wharms@bfs.de
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tty: replace mutex_lock() with tty_write_lock()
References: <1385061132-7254-1-git-send-email-andi.platschek@gmail.com> <528F112B.4090404@bfs.de>
In-Reply-To: <528F112B.4090404@bfs.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/22/2013 09:09 AM, walter harms wrote:
>
> Am 21.11.2013 20:12, schrieb Andreas Platschek:
>> Use tty_write_lock()/tty_write_unlock() consistently.
>>
>> This takes care of the following sparse warning:
>> drivers/tty/tty_io.c:1169:17: warning: context imbalance in 'tty_write_message' - unexpected unlock
>>
>> Signed-off-by: Andreas Platschek <andi.platschek@gmail.com>
>> ---
>>  drivers/tty/tty_io.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index 3a1a01a..13dca92 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -1165,7 +1165,7 @@ out:
>>  void tty_write_message(struct tty_struct *tty, char *msg)
>>  {
>>  	if (tty) {
>> -		mutex_lock(&tty->atomic_write_lock);
>> +		tty_write_lock(tty,0);
>>  		tty_lock(tty);
>>  		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
>>  			tty_unlock(tty);
> i am not an expert on this but you may need to replace that tty_unlock() with tty_write_unlock()
The tty_unlock() you see in the patch belongs to the tty_lock() right
after the tty_write_lock(), the tty_write_unlock() is already in place
without my patch.

tty_lock()/tty_unlock() and tty_write_lock()/tty_write_unlock() are
operating on different mutexes, both are needed here.

thx!
Andi
>
> re,
>  wh

