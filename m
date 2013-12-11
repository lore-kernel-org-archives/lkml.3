Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3LKDsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:48:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53091 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3LKDsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:48:22 -0500
X-IronPort-AV: E=Sophos;i="4.93,869,1378828800"; 
   d="scan'208";a="9234487"
Message-ID: <52A896E7.4050501@cn.fujitsu.com>
Date: Wed, 11 Dec 2013 11:46:31 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] perf tools: Change the default filenames for perf
 kvm diff to perf.data.xxx and perf.data.xxx.old
References: <1386778882-27906-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1386779444-29624-1-git-send-email-yangds.fnst@cn.fujitsu.com> <52A7DE4E.4070701@gmail.com>
In-Reply-To: <52A7DE4E.4070701@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/11 11:48:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/11 11:48:03,
	Serialize complete at 2013/12/11 11:48:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 10:38 PM, David Ahern wrote:
> On 12/11/13, 9:30 AM, Dongsheng Yang wrote:
>> @@ -1001,8 +1002,28 @@ static int data_init(int argc, const char **argv)
>>               use_default = false;
>>           }
>>       } else if (perf_guest) {
>> -        defaults[0] = "perf.data.host";
>> -        defaults[1] = "perf.data.guest";
>> +        char *file_name;
>> +        int len, ret;
>> +
>> +        file_name = (char *)get_filename_for_perf_kvm();
>> +        if (!file_name) {
>> +            pr_err("Failed to allocate memory for filename\n");
>> +            return -ENOMEM;
>> +        }
>> +
>
> The need for a typecast should tell you something is wrong. Why is 
> get_filename_for_perf_kvm returning a const char * when it is 
> allocated memory?
>

Yes, there is something is wrong I think. It returning const char* 
because I assume the file_name will never be changed. But now, this 
assumption seems outdated.

I will add a new patch to change the return value to char *, as the 
other two patches is already applied.
http://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=e1a2b174dbbe08dce12bde9f05f64dbbae652bed

Thanx

Yang
> David
>

