Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaESVSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:18:39 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52377 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaESVSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140518.211237.1637671513066247487.davem@davemloft.net>
References: <1400347101-25476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140518.211237.1637671513066247487.davem@davemloft.net>
Date: Mon, 19 May 2014 23:18:36 +0200
Message-ID: <CAFo99gZwnvtResqq12LJk-g0AVrZDwyAjOehvWhEnHkUx6o42g@mail.gmail.com>
Subject: Re: [PATCH] isdn: hisax: l3dss1.c: Fix for possible null pointer dereference
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Miller <davem@davemloft.net>
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Ahh, yes. That's niecer..
I am sending a new patch. If it is as you intended, I do the same with
the l3ni1.c file.


Best regards
Rickard Strandqvist


2014-05-19 3:12 GMT+02:00 David Miller <davem@davemloft.net>:
> From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> Date: Sat, 17 May 2014 19:18:21 +0200
>
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>  ...
>
>> @@ -2208,8 +2208,12 @@ static int l3dss1_cmd_global(struct PStack *st, isdn_ctrl *ic)
>>                               { free_invoke_id(st, id);
>>                                       return (-2);
>>                               }
>> -                     pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
>> -                     pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
>> +
>> +                     if (pc)
>> +                     {
>> +                             pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
>> +                             pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
>> +                     }
>
> I think rather the intention was to put these pc-> assignments in the
> timeout > 0 code block.
