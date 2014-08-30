Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaH3WRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 18:17:30 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49186 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaH3WR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 18:17:29 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
CC: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        "Maxim Patlasov" <mpatlasov@parallels.com>
Subject: RE: [PATCH v2 4/6] block: loop: say goodby to bio
Thread-Topic: [PATCH v2 4/6] block: loop: say goodby to bio
Thread-Index: AQHPxGzsGsPcDBd8qEyNy+L2yf+LBpvptC3Q
Date: Sat, 30 Aug 2014 22:14:41 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C2ECA6@G9W0745.americas.hpqcorp.net>
References: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
 <1409414907-22238-5-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1409414907-22238-5-git-send-email-ming.lei@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Ming Lei
> Sent: Saturday, 30 August, 2014 11:08 AM
> To: Jens Axboe; linux-kernel@vger.kernel.org; Dave Kleikamp
> Cc: Zach Brown; Christoph Hellwig; Maxim Patlasov; Ming Lei
> Subject: [PATCH v2 4/6] block: loop: say goodby to bio
...
> -static int do_bio_filebacked(struct loop_device *lo, struct bio
> *bio)
> +static int do_req_filebacked(struct loop_device *lo, struct request
> *rq)
>  {
>  	loff_t pos;
>  	int ret;
> 
> -	pos = ((loff_t) bio->bi_iter.bi_sector << 9) + lo->lo_offset;
> +	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
> 
> -	if (bio_rw(bio) == WRITE) {
> +	if (rq->cmd_flags & REQ_WRITE) {
>  		struct file *file = lo->lo_backing_file;
> 
> -		if (bio->bi_rw & REQ_FLUSH) {
> +		if (rq->cmd_flags & REQ_FLUSH) {
>  			ret = vfs_fsync(file, 0);
>  			if (unlikely(ret && ret != -EINVAL)) {
>  				ret = -EIO;
> @@ -436,7 +439,7 @@ static int do_bio_filebacked(struct loop_device
> *lo, struct bio *bio)
>  		 * encryption is enabled, because it may give an attacker
>  		 * useful information.
>  		 */
> -		if (bio->bi_rw & REQ_DISCARD) {
> +		if (rq->cmd_flags & REQ_DISCARD) {
>  			struct file *file = lo->lo_backing_file;
>  			int mode = FALLOC_FL_PUNCH_HOLE |
> FALLOC_FL_KEEP_SIZE;

Can a REQ_WRITE_SAME make it through to here?


---
Rob Elliott    HP Server Storage



