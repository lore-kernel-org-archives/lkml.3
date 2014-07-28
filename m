Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaG1JD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:03:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:9419 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaG1JD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:03:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="scan'208";a="576426160"
Message-ID: <53D611EC.2000907@intel.com>
Date: Mon, 28 Jul 2014 17:03:40 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, mnipxh <mnipxh@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm.c: fix a memory leak in gsmld_open
References: <53D6067C.4000702@intel.com> <53D60E8F.6080208@suse.cz>
In-Reply-To: <53D60E8F.6080208@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri

于 2014年07月28日 16:49, Jiri Slaby 写道:
> On 07/28/2014 10:14 AM, xinhui.pan wrote:
>> If gsmld_attach_gsm fails, the gsm is not used anymore.
>> tty core will not call gsmld_close to do the cleanup work.
>> tty core just restore to the tty old ldisc.
>> That always causes memory leak.
> 
> Nice catch!
> 
>> --- a/drivers/tty/n_gsm.c
>> +++ b/drivers/tty/n_gsm.c
>> @@ -2382,7 +2383,13 @@ static int gsmld_open(struct tty_struct *tty)
>>  
>>  	/* Attach the initial passive connection */
>>  	gsm->encoding = 1;
>> -	return gsmld_attach_gsm(tty, gsm);
>> +
>> +	ret = gsmld_attach_gsm(tty, gsm);
>> +	if (ret != 0) {
>> +		gsm_cleanup_mux(gsm);
>> +		mux_put(gsm);
> 
> It is quite illogical to put the mux here. It should be in gsmld_open.
> I.e. gsm_cleanup_mux here, mux_put there.
> 

Thanks for your reply :)
But I am a little confused with your comments, could you explain it when you are free?
Sorry for my poor English.

thanks,

xinhui

> thanks,
> 
