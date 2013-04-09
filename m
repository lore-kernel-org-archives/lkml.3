Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936733Ab3DIBwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:52:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47546 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3DIBwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:52:32 -0400
X-Spam-Score: -100.7
Message-ID: <51637441.2090006@asianux.com>
Date: Tue, 09 Apr 2013 09:52:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: module: strncpy issue, using strlcpy instead
 of strncpy
References: <51615AB0.9060502@asianux.com> <87r4ila8sb.fsf@rustcorp.com.au> <516298E0.9000905@asianux.com> <8738v19lv0.fsf@rustcorp.com.au>
In-Reply-To: <8738v19lv0.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月08日 21:45, Rusty Russell wrote:
>> >
>> > and for this patch, is it suitable to send patch v2 ?
> Yes, that's fine.
> 

  thanks, I will send patch v2 (the subject need delete "strncpy issue")


>>> >> However, kallsyms_lookup also calls kallsyms_expand_symbol, which
>>> >> doesn't stop at KSYM_NAME_LEN, so if a name was longer than that we'd
>>> >> have a real bug.
>>> >> 
>>> >> Would you like to take a look at that, too?
>>> >> 
>> >
>> >   it looks like a bug.  for me, I prefer to give length check for it.
>> >
>> >   but I am sorry, now, I can not be sure whether it is really a bug.
> It really is.  We don't export any symbols > 128 characters, but if we
> did then kallsyms_expand_symbol() would overflow the buffer handed to
> it.
> 
> Your suggestion about an explicit length for kallsyms_expand_symbol() is
> the correct one.


  thank you to give me additional chance to send a new patch,
  I will send another patch for it.

  since you find it, firstly, and also give a confirmation.
  can I add you as "Signed-of-by", too ?

  and excuse me:
    I think I should spend time resources to have a test for new patch.
    so I will finish it within this weekend (2013-4-14), is it OK ?


  thanks.


-- 
Chen Gang

Asianux Corporation
