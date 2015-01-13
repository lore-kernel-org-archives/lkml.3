Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbbAMVn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:43:27 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:54193 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbbAMVnZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:43:25 -0500
From: "Banerjee, Debabrata" <dbanerje@akamai.com>
To: Yuchung Cheng <ycheng@google.com>
CC: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 13 Jan 2015 16:42:50 -0500
Subject: Re: [PATCH] tcp: Fix RFC reference in comment
Thread-Topic: [PATCH] tcp: Fix RFC reference in comment
Thread-Index: AdAveeGTX4ARWf9eSeKkDSy9gAhU6Q==
Message-ID: <D0DAFA79.4435F%dbanerje@akamai.com>
References: <1421183431-29915-1-git-send-email-dbanerje@akamai.com>
 <CAK6E8=d6NMZjyH1JFoJX_ioAdQNYCAvH-G3ja9fScwW9u2=NFQ@mail.gmail.com>
In-Reply-To: <CAK6E8=d6NMZjyH1JFoJX_ioAdQNYCAvH-G3ja9fScwW9u2=NFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.7.141117
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/15, 4:36 PM, "Yuchung Cheng" <ycheng@google.com> wrote:

>On Tue, Jan 13, 2015 at 1:10 PM, Debabrata Banerjee <dbanerje@akamai.com>
>wrote:
>>
>> -/* RFC2861. Reset CWND after idle period longer RTO to "restart
>>window".
>> +/* RFC2581 4.1. Reset CWND after idle period longer RTO to "restart
>>window".
>>   * This is the first part of cwnd validation mechanism. */
>>  static void tcp_cwnd_restart(struct sock *sk, const struct dst_entry
>>*dst)
>>  {
>
>RFC2861 resets the cwnd like in RFC2581, but the rest of the code
>implements RFC2861. So I think the current comment is fine.


No RFC2861 is an experimental RFC that's implemented in
tcp_cwnd_application_limited(). RFC2861 Recommends reducing the cwnd by
averaging the current cwnd and the used cwnd as the new cwnd.


RFC2581 4.1 Says to set cwnd to initial cwnd if more than one rto has
passed since the last send. This is what is implemented in the function
above.


-Debabrata

