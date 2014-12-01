Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaLAJ57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:57:59 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:35734 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbaLAJ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:57:58 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <547C3B9D.7080002@mev.co.uk>
Date: Mon, 01 Dec 2014 09:57:49 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Chase Southwood <chase.southwood@gmail.com>,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: change some printk calls to pr_err
References: <1417410356-25504-1-git-send-email-chase.southwood@gmail.com> <20141201084735.GA2705@hudson.localdomain>
In-Reply-To: <20141201084735.GA2705@hudson.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/14 08:47, Jeremiah Mahler wrote:
> Chase,
>
> On Sun, Nov 30, 2014 at 11:05:56PM -0600, Chase Southwood wrote:
>> There are a handful of calls to printk in ni_stc.h without specified log
>> levels, as well as one in ni_mio_common.c.  This patch converts these
>> calls to pr_err() instead, so that they are now explicitly log level
>> ERR.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> ---
>> I tacked the change to ni_mio_common.c on to this patch since it's the same
>> exact change and it's just one line, so I think a single patch is justified
>> here.
>>   drivers/staging/comedi/drivers/ni_mio_common.c |  2 +-
>>   drivers/staging/comedi/drivers/ni_stc.h        | 14 +++++++-------
>>   2 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
>> index 353c17b..11e7017 100644
>> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
>> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
>> @@ -3945,7 +3945,7 @@ static unsigned ni_gpct_to_stc_register(enum ni_gpct_register reg)
>>   		stc_register = Interrupt_B_Enable_Register;
>>   		break;
>>   	default:
>> -		printk("%s: unhandled register 0x%x in switch.\n",
>> +		pr_err("%s: unhandled register 0x%x in switch.\n",
>>   		       __func__, reg);
>>   		BUG();
>>   		return 0;
> [...]
>
> On my system the default log level is 4 which corresponds to
> KERN_WARNING.  So switching to pr_err() would change the log level
> of these messages.  Using pr_warn() might be a better choice.

I wouldn't worry about the log level in this case as those printks would 
only be reached due to driver bugs.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
