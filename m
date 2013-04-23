Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3DWBtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:49:02 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19516 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3DWBtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:49:00 -0400
X-Spam-Score: -100.8
Message-ID: <5175E85F.1040509@asianux.com>
Date: Tue, 23 Apr 2013 09:48:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "paulus@samba.org" <paulus@samba.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [Suggestion] PowerPC: kernel: memory access violation when rtas_data_buf
 contents are more than 1026
References: <516F7A7D.60206@asianux.com> <1366677081.2886.7.camel@pasglop>
In-Reply-To: <1366677081.2886.7.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月23日 08:31, Benjamin Herrenschmidt wrote:
> On Thu, 2013-04-18 at 12:45 +0800, Chen Gang wrote:
>> Hello Maintainers:
>>
>>
>> in arch/powerpc/kernel/lparcfg.c, parse_system_parameter_string()
>>
>>   need set '\0' for 'local_buffer'.
>>
>>   the reason is:
>>     SPLPAR_MAXLENGTH is 1026, RTAS_DATA_BUF_SIZE is 4096
>>     the contents of rtas_data_buf may truncated in memcpy (line 301).
>>
>>     if contents are truncated.
>>       the splpar_strlen is more than 1026 (line 321)
>>       the while loop checking will not find the end of buffer (line 326)
>>       it will cause memory access violation.
>>
>>
>>   I find it by reading code, so please help check.
> 
> And a signed-off-by please ?
> 

  ok, thanks, I should send the related patch.


-- 
Chen Gang

Asianux Corporation
