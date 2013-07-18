Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3GRHaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:30:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21377 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3GRHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:30:17 -0400
X-Spam-Score: -100.8
Message-ID: <51E7994D.1060300@asianux.com>
Date: Thu, 18 Jul 2013 15:29:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, George Spelvin <linux@horizon.com>
CC: reiserfs-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: check/extend buffer length for printing functions
References: <51E65A68.8070009@asianux.com> <51E76ED7.303@asianux.com>
In-Reply-To: <51E76ED7.303@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 12:28 PM, Chen Gang wrote:
>  
>>  	strcpy(fmt1, fmt);
>> @@ -199,46 +214,51 @@ static void prepare_error_buf(const char *fmt, va_list args)
>>  	while ((k = is_there_reiserfs_struct(fmt1, &what)) != NULL) {
>>  		*k = 0;
>>  
>> -		p += vsprintf(p, fmt1, args);
>> +		p += vsnprintf(p, left, fmt1, args);

At least, need use vscnprintf() instead of vsnprintf(), since we need
the real written length return.

>> +		left = REISERFS_ERR_BUF_LEFT(p, error_buf);
>>  
>>  		switch (what) {
>>  		case 'k':
>> -			sprintf_le_key(p, va_arg(args, struct reiserfs_key *));
>> +			sprintf_le_key(p, left,
>> +				       va_arg(args, struct reiserfs_key *));
>>  			break;
>>  		case 'K':
>> -			sprintf_cpu_key(p, va_arg(args, struct cpu_key *));
>> +			sprintf_cpu_key(p, left,
>> 


-- 
Chen Gang
