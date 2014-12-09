Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaLIQaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:30:08 -0500
Received: from nm44-vm7.bullet.mail.bf1.yahoo.com ([216.109.115.31]:36442 "EHLO
	nm44-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626AbaLIQaG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:30:06 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 11:30:06 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.ca;
	b=UlYiLATdZLdftT5o+7hrDV0srtXeu+qlq4ZmvB2V0sjmVDDMx+qi5JX0bA13nhB6UQUxlrIcRdAbX6NpvgQ3ISKThwzzkfN+7ica7g/HgXSRcz13uo6tiy5+zsR1kluxNl0y39Ggz6Vzh6FDSIMbi20XFe5Il5XTjFKX7sisG1UZA6IKWbL60X2GrODSjxqyAob+5kRz57BdEZqx6RsE/P3IzRgTIORTKmFUsSauIT7s97eYvHxz5p++N8PSQXQlB8tbfd1PK2McW9GCDg034Fvn96IQj/h9aQ8JiR6sMS2QPWHVh4OyU9PhwOKR+ma7fl0J5WjYhggnQRY90BLNhQ==;
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 547550.19114.bm@omp1022.mail.bf1.yahoo.com
X-YMail-OSG: c72GeEcVM1nsn3lwHukeC4xXoZm3.JRQPOUnR5b.0QvFd2TI8au5L4vmJCJKy8x
 wX8n0hWCvUAj282hHNcRwliSGG4ZDiQxNjNaMvkrl13_gDOuk.7DwTSxq.CbvIMCoLdTi4N0M6k3
 PLAk7QK.Xx8npm5SZ7NhrPTDd_u.775E7oaKOhKKuZEsnvkumU8k2EXOK81uhkPc3jfJe2OpgqaM
 0edALZERsS_qLI5MS.vGD5_rdb_WecVQcS0IlY5OXc_RPCKEzOJ6Ilczt9Co0fTpaSyH6O8wXLul
 DcgsbvgE8o7oWdj0AE3i75g.7wLUBj0halEC_6RszW1CQYjZdXQjkajBv6z2r.rqHKFhBK89FP9G
 dgiSDnx476NKgUUukjv1uEfN8UBrTt6xW.Nf14srxO1AWiT8VFzOcsukOBduHc0C.8hk3MEh8Nry
 PehM_UklbBxZU9CifoWQEG8i4qDDw5LJcvDry9S07fAG_6w4aDQ.s1Yf9zAXKdk_.Z1cWtCCxsfI
 uNqgiYu4Yq7VDlPBYN8fuevnwdl2Yc9Gwz1gETRyH_8zV.zqZbNforu.QSoisHcV.5aSh56mYDLw
 HUdcpxabDIuXB
Date: Tue, 9 Dec 2014 16:23:54 +0000 (UTC)
From: Denis Du <dudenis2000@yahoo.ca>
Reply-To: Denis Du <dudenis2000@yahoo.ca>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <1071981694.7326020.1418142234750.JavaMail.yahoo@jws10644.mail.bf1.yahoo.com>
In-Reply-To: <20141208222220.GA9912@hudson.localdomain>
References: <20141208222220.GA9912@hudson.localdomain>
Subject: Re: [PATCH] TTY: missing a lock to access the ldisk buffer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jeremiah:

This patch was generated base on 3.12 kernel. But possibly I have a wrong format to put this patch on a plain text. I am working to do a new patch now.

 
Denis Du


----- Original Message -----
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Denis Du <dudenis2000@yahoo.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Monday, December 8, 2014 5:22 PM
Subject: Re: [PATCH] TTY: missing a lock to access the ldisk buffer

Denis,

This patch won't apply to linux-next 20141208 so I can't test it :-(

Which kernel does this patch apply to?


On Mon, Dec 08, 2014 at 08:28:00PM +0000, Denis Du wrote:
> Hi, Guys:
> I found that the 3.12 kernel tty layer will lose or corrupt data when having a full-duplex communication, especcially in high baudrate, for example 230k for my OMAP5 uart. Eventually I found there is a lock missing between copy data to ldisc layer buffer and copy data from the same buffer to user space. I believe this issue have been existing since 3.8 kernel(since this kernel , it start to remove most of the spin-locks) and I didn't find any fix even through 3.17 kernel. This patch was tested to be works great with no any data loss again.
> 
> 
> I did try to use the existed lock atomic_read_lock, but it doesn’t work. 
> 
> 
> 
> Signed-off-by: Hui Du <dudenis2000@yahoo.ca>
> 
> 
> ---
> 
> --- drivers/tty/n_tty.c    2014-10-16 16:39:35.909350338 -0400
> +++ drivers/tty/n_tty.c    2014-10-16 16:49:00.004930469 -0400
> @@ -124,6 +124,7 @@
> 
> struct mutex atomic_read_lock;
> struct mutex output_lock;
> +    struct mutex read_buf_lock;
> };
> 
> static inline size_t read_cnt(struct n_tty_data *ldata)
> @@ -1686,9 +1687,11 @@
> char *fp, int count)
> {
> int room, n;
> +    struct n_tty_data *ldata = tty->disc_data;
> 
> down_read(&tty->termios_rwsem);
> 
> +    mutex_lock(&ldata->read_buf_lock);
> while (1) {
> room = receive_room(tty);
> n = min(count, room);
> @@ -1703,6 +1706,7 @@
> 
> tty->receive_room = room;
> n_tty_check_throttle(tty);
> +    mutex_unlock(&ldata->read_buf_lock);
> up_read(&tty->termios_rwsem);
> }
> 
> @@ -1713,7 +1717,7 @@
> int room, n, rcvd = 0;
> 
> down_read(&tty->termios_rwsem);
> -
> +    mutex_lock(&ldata->read_buf_lock);
> while (1) {
> room = receive_room(tty);
> n = min(count, room);
> @@ -1732,6 +1736,7 @@
> 
> tty->receive_room = room;
> n_tty_check_throttle(tty);
> +    mutex_unlock(&ldata->read_buf_lock);
> up_read(&tty->termios_rwsem);
> 
> return rcvd;
> @@ -1880,6 +1885,7 @@
> ldata->overrun_time = jiffies;
> mutex_init(&ldata->atomic_read_lock);
> mutex_init(&ldata->output_lock);
> +    mutex_init(&ldata->read_buf_lock);
> 
> tty->disc_data = ldata;
> reset_buffer_flags(tty->disc_data);
> @@ -1945,6 +1951,8 @@
> size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
> 
> retval = 0;
> +
> +    mutex_lock(&ldata->read_buf_lock);
> n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
> n = min(*nr, n);
> if (n) {
> @@ -1960,6 +1968,7 @@
> *b += n;
> *nr -= n;
> }
> +    mutex_unlock(&ldata->read_buf_lock);
> return retval;
> }
> 
> @@ -1990,6 +1999,8 @@
> size_t tail;
> int ret, found = 0;
> bool eof_push = 0;
> + 
> +    mutex_lock(&ldata->read_buf_lock);
> 
> /* N.B. avoid overrun if nr == 0 */
> n = min(*nr, read_cnt(ldata));
> @@ -2049,6 +2060,8 @@
> ldata->line_start = ldata->read_tail;
> tty_audit_push(tty);
> }
> +
> +    mutex_unlock(&ldata->read_buf_lock);
> return eof_push ? -EAGAIN : 0;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
