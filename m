Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573Ab3DDQ7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:59:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33319 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763464Ab3DDQ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:59:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,410,1363158000"; 
   d="scan'208";a="35906979"
Message-ID: <515DB152.603@codeaurora.org>
Date: Thu, 04 Apr 2013 11:58:58 -0500
From: Richard Kuo <rkuo@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: linasvepstas@gmail.com
CC: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/6] Hexagon: check to if we will overflow the signal
 stack
References: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org> <1365033776-21804-5-git-send-email-rkuo@codeaurora.org> <CAHrUA37oTkv-x5f4zZVwqjWAqvyMdwXAokw1EDBHiGv8ozWxVQ@mail.gmail.com>
In-Reply-To: <CAHrUA37oTkv-x5f4zZVwqjWAqvyMdwXAokw1EDBHiGv8ozWxVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 11:25 AM, Linas Vepstas wrote:
> On 3 April 2013 19:02, Richard Kuo <rkuo@codeaurora.org> wrote:
>
>> +       /* check if we would overflow the alt stack */
>> +       if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
>> +               return (void __user __force *)-1UL;
> I found the !likely construction confusing, as its doing both a
> 'unlikely' (right?) and inverting the argument. It seems clearer,
> to idiots like me, to write this as:
>
> if (on_sig_stack(sp) && unlikely(!on_sig_stack(sp - frame_size)))
>
> since where checking for overflow, and its unlikely that the overflow happened.
>
> -- Linas

I'm not sure if putting a double negative in there will make it less not 
easy to understand...


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

