Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3IXUqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:46:43 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40463 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3IXUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130924.152833.434453431118381771.davem@redhat.com>
References: <1380046281-6012-1-git-send-email-vincent.mc.li@gmail.com>
	<20130924.152833.434453431118381771.davem@redhat.com>
Date: Tue, 24 Sep 2013 13:46:41 -0700
Message-ID: <CAK3+h2y7v0i7AgK02GSy1apKKsi8n7is7U8oypx=uBf49Bubbg@mail.gmail.com>
Subject: Re: [PATCH] Allow userspace code to use flag IFA_F_SECONDARY to
 specify an ip address to be primary or secondary ip on an interface
From: Vincent Li <vincent.mc.li@gmail.com>
To: David Miller <davem@redhat.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I will resend the patch with your suggestions.

Vincent

On Tue, Sep 24, 2013 at 12:28 PM, David Miller <davem@redhat.com> wrote:
> From: Vincent Li <vincent.mc.li@gmail.com>
> Date: Tue, 24 Sep 2013 11:11:21 -0700
>
>> the current behavior is when an IP is added to an interface, the primary
>> or secondary attributes is depending on the order of ip added to the interface
>> the first IP will be primary and second, third,... or alias IP will be secondary
>> if the IP subnet matches
>>
>> this patch add the flexiblity to allow user to specify an argument 'primary' or 'secondary'
>> (use 'ip addr add ip/mask primary|secondary dev ethX ' from iproute2 for example) to specify
>> an IP address to be  primary or secondary.
>>
>> the reason for this patch is that we have a multi blade cluster platform sharing 'floating management ip'
>> and also that each blade has its own management ip on the management interface, so whichever blade in the
>> cluster becomes primary blade, the 'floating mangaement ip' follows it, and we want any of our traffic
>> originated from the primary blade source from the 'floating management ip' for consistency. but in this
>> case, since the local blade management ip is always the primary ip on the mangaement interface and 'floating
>> management ip' is always secondary, kernel always choose the primary ip as source ip address. thus we would
>> like to add the flexibility in kernel to allow us to specify which ip to be primary or secondary.
>>
>> Signed-off-by: Vincent Li <vincent.mc.li@gmail.com>
>
> When submitting a patch, please:
>
> 1) Specify an appropriate prefix for your subject line, indicating the
>    subsystem.  "ipv4: " might be appropriate here.
>
> 2) Format your commit message so that lines do not exceed 80 columns.
>    People will read using ASCII text based tools in 80 column
>    terminals.
