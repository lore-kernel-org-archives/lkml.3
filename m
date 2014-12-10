Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaLJS6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:58:41 -0500
Received: from nm21.bullet.mail.bf1.yahoo.com ([98.139.212.180]:38130 "EHLO
	nm21.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932501AbaLJS6k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:58:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.ca;
	b=YE8QAB5B6c8FBcoxCj0C5tWg4KFNVOg6EiDnWXxc4gEVckFGhMxfSK6wJnHZCF71kv4RNWo69/T0m2EgyVO/wL70TcgAxBS3KqSpPwsJ5PjDL+iYbAzBKipdvYDFt9H4Kf/cM+WassDinIp8y1pEI6CQ1P5MZrPNTMoYLKU6C5fvmcoV7MXfTAq7mE9Otv8eYlk+1hjGsLc389uJWoBNuVL8JSr7tmWlI3J8RvuSfZn8BEHpY+1byTw2HqcnuG6r5fQhlZ4cdCPZQXJ5MwDf+s6I6rhGvlofCSjNPDY7NJvOWUxsQFDnPDqW6aH7E6ph38rqZy08e3bo/qhwXMyiaw==;
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 749526.66649.bm@omp1017.mail.bf1.yahoo.com
X-YMail-OSG: bXnOW54VM1kX4GkGoAPTMpIZDbX4QxSuItdB3c0kOmU8X4g0H4OWLaqKLxn.247
 TqZIPyOYXicZTdIzMqXBNOWyMhfMTK.tBOmTpT9Ntkzpni.mCVm3QOybgOrjmxhVv24tKkHtylWw
 yYj.TJKFsE1nFjrqlIDu1EAm42wrKkLcjFV6kwAEBpBgjG8o1p4_wtUvt_KcKAWTmN1HsZ1vNBuZ
 yxqVLSIk1b7zv2sIJ_udi2WZ1CoN5LqG85rJezOItd5CRwoZlfgxjx82StK57ZkWqXFLtpHjUwt8
 hpKraiKisAzsHQDTXGZ0alyHH3wTlC8L.T1Zpucuhoi1O0WO8q3RlXHwG9XXHTOkJI2vZAxrM2Tz
 Khtot46KlTYu05dk_ihflvnazrtVZ36U0e2XYCpb1eJgWH9I9VHqrDPWisaeF.GWuoMFSqa9yAOb
 MVFZ3dkU4gQj8PBHBVjmgSN43EkeGYoVHFK2ngtIKQam9DPZl2T9c7k_Qxo9kkv_eRTT.YJNrYdi
 33QkNhuVTX2tp13L3m6vFVrPVOgiph8.pPf08roVNm.goYjSk.cHd.Pqd0tG2k.IrWZ8K6OkrwuY
 tZCoxYOjp2z9lWA--
Date: Wed, 10 Dec 2014 18:57:40 +0000 (UTC)
From: Denis Du <dudenis2000@yahoo.ca>
Reply-To: Denis Du <dudenis2000@yahoo.ca>
To: Jiri Slaby <jslaby@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jmmahler@gmail.com" <jmmahler@gmail.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>
Message-ID: <166984712.4678215.1418237860359.JavaMail.yahoo@jws10661.mail.bf1.yahoo.com>
In-Reply-To: <548895D9.6090402@suse.cz>
References: <548895D9.6090402@suse.cz>
Subject: Re: [PATCH] TTY: Fix the missing lock for the TTY ldisc buffer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 


On 12/10/2014, 07:38 PM, Denis Du wrote:
> 
> Hi, Guys:

Hi, are you sending this using some robot? I think I have seen like ten
copies of this patch already.



Sorry, I always have troubles to send the patch in correct format, even now I am not 

100% sure this patch have the correct format. My company's firewall policy messed up
many things, I have to try my yahoo personal e-mail.

> It was found that the 3.12 kernel tty layer will lose or corrupt data
> when have a full-duplex communication, especially in high baud rate, for
> example 230k for my OMAP5 uart. Eventually I found there is lock missing
> between copy data to ldisc layer buffer and copy data from the same
> buffer to user space. I believe this issue existed since 3.8
> kernel(since this kernel , it start to remove most of the spin-locks)
> and I didn't find any fix even through 3.17 kernel. This patch was
> tested to be works great with no any data loss again on 3.12 kernel.
> 
> This patch was built for the latest kernel, but I cannot test it.
> Somebody may give a test.
> 
> I did try to use the existed lock atomic_read_lock, but it doesn’t work.

Anyway, adding Peter Hurley to CC who was working on eliminating locks
from this code lately. More precisely since 3.12 we have no locks there,
which would explain why are you seeing it starting 3.12.

> Signed-off-by: Hui Du <dudenis2000@yahoo.ca>
> 
> ---
>  drivers/tty/n_tty.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 2e900a9..6e5c6ae 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -125,6 +125,7 @@ struct n_tty_data {
>  
>      struct mutex atomic_read_lock;
>      struct mutex output_lock;
> +    struct mutex read_buf_lock;
>  };
>  
>  static inline size_t read_cnt(struct n_tty_data *ldata)
> @@ -1691,7 +1692,7 @@ n_tty_receive_buf_common(struct tty_struct *tty,
> const unsigned char *cp,
>      int room, n, rcvd = 0;
>  
>      down_read(&tty->termios_rwsem);
> -
> +    mutex_lock(&ldata->read_buf_lock);
>      while (1) {
>          room = receive_room(tty);
>          n = min(count, room);
> @@ -1710,6 +1711,7 @@ n_tty_receive_buf_common(struct tty_struct *tty,
> const unsigned char *cp,
>  
>      tty->receive_room = room;
>      n_tty_check_throttle(tty);
> +    mutex_unlock(&ldata->read_buf_lock);
>      up_read(&tty->termios_rwsem);
>  
>      return rcvd;
> @@ -1876,6 +1878,7 @@ static int n_tty_open(struct tty_struct *tty)
>      ldata->overrun_time = jiffies;
>      mutex_init(&ldata->atomic_read_lock);
>      mutex_init(&ldata->output_lock);
> +    mutex_init(&ldata->read_buf_lock);
>  
>      tty->disc_data = ldata;
>      reset_buffer_flags(tty->disc_data);
> @@ -1939,6 +1942,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
>      size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
>  
>      retval = 0;
> +    mutex_lock(&ldata->read_buf_lock);
>      n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
>      n = min(*nr, n);
>      if (n) {
> @@ -1954,6 +1958,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
>          *b += n;
>          *nr -= n;
>      }
> +    mutex_unlock(&ldata->read_buf_lock);
>      return retval;
>  }
>  
> @@ -1992,6 +1997,7 @@ static int canon_copy_from_read_buf(struct
> tty_struct *tty,
>      bool eof_push = 0;
>  
>      /* N.B. avoid overrun if nr == 0 */
> +    mutex_lock(&ldata->read_buf_lock);
>      n = min(*nr, read_cnt(ldata));
>      if (!n)
>          return 0;
> @@ -2052,6 +2058,7 @@ static int canon_copy_from_read_buf(struct
> tty_struct *tty,
>              ldata->push = 0;
>          tty_audit_push(tty);
>      }
> +    mutex_unlock(&ldata->read_buf_lock);
>      return eof_push ? -EAGAIN : 0;
>  }
>  


-- 
js
suse labs

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
