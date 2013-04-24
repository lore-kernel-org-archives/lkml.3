Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab3DXHll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:41:41 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15748 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3DXHlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:41:40 -0400
X-Spam-Score: -100.8
Message-ID: <51778C82.2080807@asianux.com>
Date: Wed, 24 Apr 2013 15:40:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] PowerPC: kernel: memory access violation when rtas_data_buf
 contents are more than 1026
References: <516F7A7D.60206@asianux.com> <1366677081.2886.7.camel@pasglop> <5175E85F.1040509@asianux.com> <5175FC36.4060308@asianux.com> <51777B74.8040204@linux.vnet.ibm.com> <517783D8.6010701@asianux.com> <51778885.6090306@linux.vnet.ibm.com>
In-Reply-To: <51778885.6090306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月24日 15:23, Vasant Hegde wrote:
> On 04/24/2013 12:33 PM, Chen Gang wrote:
>> On 2013年04月24日 14:28, Vasant Hegde wrote:
>>> On 04/23/2013 08:42 AM, Chen Gang wrote:
>>>>
>>>> need set '\0' for 'local_buffer'.
>>>>
>>>> SPLPAR_MAXLENGTH is 1026, RTAS_DATA_BUF_SIZE is 4096. so the
>>>> contents of
>>>> rtas_data_buf may truncated in memcpy.
>>>>
>>>> if contents are really truncated.
>>>>     the splpar_strlen is more than 1026. the next while loop
>>>> checking will
>>>>     not find the end of buffer. that will cause memory access
>>>> violation.
>>>>
>>>
>>> Per parameter length in ibm,get-system-parameter RTAS call is limited to
>>> 1026 bytes (1024 bytes of data + 2 bytes  length). And 'rtas_data_buf'
>>> was set to 0 (first 1026 bytes) before call RTAS call. At the worst if
>>> we get junk in RTAS output length field helps to exit from the while
>>> loop. So I don't think we need this patch.
>>
>> Is get-system-parameter return the NUL terminated string ? if so, it
>> will no issue (just like your discription).
>>
> 
> Length includes the length of the NULL. So (idx < splpar_strlen)
> is safe. IMO existing code is proper.

OK, since it is not an issue, I will try another patches for powerpc POWER7.

  :-)

-- 
Chen Gang

Asianux Corporation
