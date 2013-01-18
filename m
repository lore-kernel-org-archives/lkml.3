Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3ARWEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:04:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3ARWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:04:02 -0500
Message-ID: <50F9C6C6.1090702@oracle.com>
Date: Fri, 18 Jan 2013 16:03:50 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH V5 17/30] fs: use read_iter and write_iter rather than
 aio_read and aio_write
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com> <1357761525-22718-18-git-send-email-dave.kleikamp@oracle.com> <x497gnai3nn.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497gnai3nn.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/18/2013 03:26 PM, Jeff Moyer wrote:
> Dave Kleikamp <dave.kleikamp@oracle.com> writes:
> 
>> @@ -1315,10 +1317,10 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
>>  
>>  	if ((iocb->ki_opcode == IOCB_CMD_PREADV) ||
>>  		(iocb->ki_opcode == IOCB_CMD_PREAD)) {
>> -		rw_op = file->f_op->aio_read;
>> +		rw_op = do_aio_read;
>>  		opcode = IOCB_CMD_PREADV;
>>  	} else {
>> -		rw_op = file->f_op->aio_write;
>> +		rw_op = do_aio_read;
>>  		opcode = IOCB_CMD_PWRITEV;
>>  	}
> 
> That wants to be rw_op = do_aio_write in the else clause.  How did you
> test this patch set?

Yep, that's certainly a bug. I concentrated on testing on loop mounts,
running some fio and ltp testcases, but I'm at a loss to explain how
things seem to work as well as they do. Let's see how where fixing this
leads.

Thanks!
Shaggy

> Cheers,
> Jeff
> 
