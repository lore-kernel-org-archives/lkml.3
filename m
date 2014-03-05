Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaCES6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:58:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbaCES6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:58:52 -0500
Message-ID: <531773EB.6010908@canonical.com>
Date: Wed, 05 Mar 2014 18:58:51 +0000
From: Colin Ian King <colin.king@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: ipc: handle msgget failure return correctly
References: <1394041873-4220-1-git-send-email-colin.king@canonical.com> <20140305185046.GA6708@bender.morinfr.org>
In-Reply-To: <20140305185046.GA6708@bender.morinfr.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 18:50, Guillaume Morin wrote:
> On 05 Mar 17:51, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> A failed msgget causes the test to return an uninitialised value
>> in ret. Assign ret to -errno on error exit.
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  tools/testing/selftests/ipc/msgque.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
>> index d664182..be8f294 100644
>> --- a/tools/testing/selftests/ipc/msgque.c
>> +++ b/tools/testing/selftests/ipc/msgque.c
>> @@ -202,6 +202,7 @@ int main(int argc, char **argv)
>>  	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
>>  	if (msgque.msq_id == -1) {
>>  		printf("Can't create queue\n");
>> +		err = -errno;
>>  		goto err_out;
>>  	}
>>  
>> -- 
> 
> Maybe I am nitpicking here but printf() could modify errno, so you might
> as well save it before printf() is called.
> 
Yep, new patch been sent.
