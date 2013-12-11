Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3LKDi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:38:58 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:65343 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3LKDi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:38:56 -0500
Message-ID: <52A7DE4E.4070701@gmail.com>
Date: Tue, 10 Dec 2013 20:38:54 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] perf tools: Change the default filenames for perf
 kvm diff to perf.data.xxx and perf.data.xxx.old
References: <1386778882-27906-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1386779444-29624-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1386779444-29624-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 9:30 AM, Dongsheng Yang wrote:
> @@ -1001,8 +1002,28 @@ static int data_init(int argc, const char **argv)
>   			use_default = false;
>   		}
>   	} else if (perf_guest) {
> -		defaults[0] = "perf.data.host";
> -		defaults[1] = "perf.data.guest";
> +		char *file_name;
> +		int len, ret;
> +
> +		file_name = (char *)get_filename_for_perf_kvm();
> +		if (!file_name) {
> +			pr_err("Failed to allocate memory for filename\n");
> +			return -ENOMEM;
> +		}
> +

The need for a typecast should tell you something is wrong. Why is 
get_filename_for_perf_kvm returning a const char * when it is allocated 
memory?

David
