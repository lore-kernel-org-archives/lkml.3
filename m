Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaE1Ve5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:34:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:42739 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaE1Vez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:34:55 -0400
Message-ID: <5386563F.8000901@windriver.com>
Date: Wed, 28 May 2014 15:33:51 -0600
From: Chris Friesen <chris.friesen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "'Arnaldo Carvalho de Melo'" <acme@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?ISO-8859-1?Q?Ondrej_B=EDlka?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
References: <537E0961.8040005@gmail.com> <20140526134647.GB8176@kernel.org> <20140526211706.GA25474@kernel.org> <5384BEC5.2080607@gmail.com> <20140527192115.GD25474@kernel.org> <CAKgNAkht1vubHueYPpkRu_W5B8OYW3rPUkHeLEq5WMVbCvO47w@mail.gmail.com> <20140527203010.GA2764@kernel.org> <5385D47A.3070401@gmail.com> <20140528150720.GB2764@kernel.org> <063D6719AE5E284EB5DD2968C1650D6D1724F2A0@AcuExch.aculab.com> <20140528195004.GD2764@kernel.org>
In-Reply-To: <20140528195004.GD2764@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.119.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 01:50 PM, 'Arnaldo Carvalho de Melo' wrote:

> What is being discussed here is how to return the EFAULT that may happen
> _after_ datagram processing, be it interrupted by an EFAULT, signal, or
> plain returning all that was requested, with no errors.
>
> This EFAULT _after_ datagram processing may happen when updating the
> remaining timeout, because then how can userspace both receive the
> number of successfully copied datagrams (in any of the cases mentioned
> in the previous paragraph) and know that that timeout can't be used
> because there was a problem while trying to copy it to userspace
> (EFAULT)?


How does select() handle this problem?  It updates the timeout and also 
modifies other data.

Could we just check whether the timeout pointer is valid before doing 
anything else?  Of course we could still fault the page out while 
waiting for messages and then fail to fault it back in later, but that 
seems like a not-very-likely scenario.

Chris
