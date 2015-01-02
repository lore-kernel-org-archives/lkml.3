Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbbABOvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 09:51:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbABOvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 09:51:09 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel\@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf\@aepfle.de" <olaf@aepfle.de>,
        "apw\@canonical.com" <apw@canonical.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
References: <1418211200-1166-1-git-send-email-decui@microsoft.com>
	<F792CF86EFE20D4AB8064279AFBA51C613EA4E5F@SIXPRD3002MB028.064d.mgd.msft.net>
Date: Fri, 02 Jan 2015 15:50:52 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613EA4E5F@SIXPRD3002MB028.064d.mgd.msft.net>
	(Dexuan Cui's message of "Wed, 17 Dec 2014 01:57:06 +0000")
Message-ID: <87lhllqlrn.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

>> -----Original Message-----
>> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
>> Behalf Of Dexuan Cui
>> Sent: Wednesday, December 10, 2014 19:33 PM
>> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
>> devel@linuxdriverproject.org; vkuznets@redhat.com; olaf@aepfle.de;
>> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
>> Cc: Haiyang Zhang
>> Subject: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
>> 
>> In the case the host only injects an IPv6 address, the dhcp_enabled flag is
>> true (it's only for IPv4 according to Hyper-V host team), but we still need to
>> proceed to parse the IPv6 information.
>> 
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: K. Y. Srinivasan <kys@microsoft.com>
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>> ---
>> 
>> v2: removed the distro-specific logic as Vitaly suggested.
>> 
>>  tools/hv/hv_kvp_daemon.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
>> index 6a6432a..4b3ee35 100644
>> --- a/tools/hv/hv_kvp_daemon.c
>> +++ b/tools/hv/hv_kvp_daemon.c
>> @@ -1308,16 +1308,17 @@ static int kvp_set_ip_info(char *if_name, struct
>> hv_kvp_ipaddr_value *new_val)
>>  	if (error)
>>  		goto setval_error;
>> 
>> +	/*
>> +	 * The dhcp_enabled flag is only for IPv4. In the case the host only
>> +	 * injects an IPv6 address, the flag is true, but we still need to
>> +	 * proceed to parse and pass the IPv6 information to the
>> +	 * disto-specific script hv_set_ifconfig.
>> +	 */

Actually we just relay what was recieved from the host and it's up to
distro-specific script how to interpret BOOTPROTO=dhcp now. Additional
IPv4 addresses (in case we receive them from our host) are not skipped
now as well.

>>  	if (new_val->dhcp_enabled) {
>>  		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
>>  		if (error)
>>  			goto setval_error;
>> 
>> -		/*
>> -		 * We are done!.
>> -		 */
>> -		goto setval_done;
>> -
>>  	} else {
>>  		error = kvp_write_file(file, "BOOTPROTO", "", "none");
>>  		if (error)
>> @@ -1345,7 +1346,6 @@ static int kvp_set_ip_info(char *if_name, struct
>> hv_kvp_ipaddr_value *new_val)
>>  	if (error)
>>  		goto setval_error;
>> 
>> -setval_done:
>>  	fclose(file);
>> 
>>  	/*
>> --
>> 1.9.1
>
> Hi Vitaly,
> Can you please ACK the v2 patch?

Sorry it took me so long to reply, last 3 weeks I was on vacation. I'm
not particulary sure I'm in charge here to give an ACK :-), but 

Reviewed-By: Vitaly Kuznetsov <vkuznets@redhat.com>

> Or, please let me know if you have new comments.
>
> Thanks,
> -- Dexuan

-- 
  Vitaly
