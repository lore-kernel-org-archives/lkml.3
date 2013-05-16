Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3EPLi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:38:58 -0400
Received: from intranet.asianux.com ([58.214.24.6]:8637 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3EPLi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:38:57 -0400
X-Spam-Score: -100.7
Message-ID: <5194C51D.2000205@asianux.com>
Date: Thu, 16 May 2013 19:38:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: jason.wessel@windriver.com, Anton Vorontsov <anton@enomsg.org>,
        sasha.levin@oracle.com, vincent.stehle@laposte.net,
        john.blackwood@ccur.com
CC: kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: debug: kdb: strncpy issue, using strlcpy instead
 of strncpy.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check and apply this patch when you hanve time, thanks.

It is already Acked-by Anton, please see below.

Thanks.


On Wed, Apr 17, 2013 at 05:43:13PM +0800, Chen Gang wrote:
> Hello maintainers:
>
>   please help check this patch, when you have time, thanks.
>

The patch looks good. I would add to the description: "..., otherwise the
destination string might end up not being terminted with the NUL, causing
all sorts of misbehaviour."

	Acked-by: Anton Vorontsov <anton@enomsg.org>

Thanks!

> On 2013年04月07日 19:03, Chen Gang wrote:
>>
>>   cmd_cur and cmd_hist[] are all NUL terminated string.
>>   need using strlcpy instead of strncpy.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/debug/kdb/kdb_main.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
>> index 00eb8f7..a2b04d7 100644
>> --- a/kernel/debug/kdb/kdb_main.c
>> +++ b/kernel/debug/kdb/kdb_main.c
>> @@ -1063,12 +1063,12 @@ static int handle_ctrl_cmd(char *cmd)
>>  	case CTRL_P:
>>  		if (cmdptr != cmd_tail)
>>  			cmdptr = (cmdptr-1) % KDB_CMD_HISTORY_COUNT;
>> -		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
>> +		strlcpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
>>  		return 1;
>>  	case CTRL_N:
>>  		if (cmdptr != cmd_head)
>>  			cmdptr = (cmdptr+1) % KDB_CMD_HISTORY_COUNT;
>> -		strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
>> +		strlcpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
>>  		return 1;
>>  	}
>>  	return 0;
>> @@ -1260,7 +1260,7 @@ do_full_getstr:
>>  		if (*cmdbuf != '\n') {
>>  			if (*cmdbuf < 32) {
>>  				if (cmdptr == cmd_head) {
>> -					strncpy(cmd_hist[cmd_head], cmd_cur,
>> +					strlcpy(cmd_hist[cmd_head], cmd_cur,
>>  						CMD_BUFLEN);
>>  					*(cmd_hist[cmd_head] +
>>  					  strlen(cmd_hist[cmd_head])-1) = '\0';
>> @@ -1270,7 +1270,7 @@ do_full_getstr:
>>  				cmdbuf = cmd_cur;
>>  				goto do_full_getstr;
>>  			} else {
>> -				strncpy(cmd_hist[cmd_head], cmd_cur,
>> +				strlcpy(cmd_hist[cmd_head], cmd_cur,
>>  					CMD_BUFLEN);
>>  			}
>>  
>>
>
>
> -- 
> Chen Gang
>
> Asianux Corporation




