Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbbAMWBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:01:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:35840 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbAMWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:01:30 -0500
MIME-Version: 1.0
In-Reply-To: <D0DAFA79.4435F%dbanerje@akamai.com>
References: <1421183431-29915-1-git-send-email-dbanerje@akamai.com>
	<CAK6E8=d6NMZjyH1JFoJX_ioAdQNYCAvH-G3ja9fScwW9u2=NFQ@mail.gmail.com>
	<D0DAFA79.4435F%dbanerje@akamai.com>
Date: Tue, 13 Jan 2015 17:01:28 -0500
Message-ID: <CABrhC0m=aPO=OcfK_gTusHz7CU9OUeXAHoqUDaVTGLDiQnL56Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: Fix RFC reference in comment
From: John Heffner <johnwheffner@gmail.com>
To: "Banerjee, Debabrata" <dbanerje@akamai.com>
Cc: Yuchung Cheng <ycheng@google.com>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 4:42 PM, Banerjee, Debabrata
<dbanerje@akamai.com> wrote:
> On 1/13/15, 4:36 PM, "Yuchung Cheng" <ycheng@google.com> wrote:
>
>>On Tue, Jan 13, 2015 at 1:10 PM, Debabrata Banerjee <dbanerje@akamai.com>
>>wrote:
>>>
>>> -/* RFC2861. Reset CWND after idle period longer RTO to "restart
>>>window".
>>> +/* RFC2581 4.1. Reset CWND after idle period longer RTO to "restart
>>>window".
>>>   * This is the first part of cwnd validation mechanism. */
>>>  static void tcp_cwnd_restart(struct sock *sk, const struct dst_entry
>>>*dst)
>>>  {
>>
>>RFC2861 resets the cwnd like in RFC2581, but the rest of the code
>>implements RFC2861. So I think the current comment is fine.
>
>
> No RFC2861 is an experimental RFC that's implemented in
> tcp_cwnd_application_limited(). RFC2861 Recommends reducing the cwnd by
> averaging the current cwnd and the used cwnd as the new cwnd.
>
>
> RFC2581 4.1 Says to set cwnd to initial cwnd if more than one rto has
> passed since the last send. This is what is implemented in the function
> above.

Look at the code a little closer -- it's decaying cwnd based on number
of timeouts as described in 2861, not resetting to IW as recommended
in 2581.

  -John
