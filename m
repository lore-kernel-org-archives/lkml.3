Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaIZTeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:34:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53026 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaIZTel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:34:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Ahern <lxhacker68@gmail.com>
Cc: nicolas.dichtel@6wind.com, Cong Wang <cwang@twopensource.com>,
        netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
	<54228D87.3070309@6wind.com>
	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
	<5422F0F4.6000709@6wind.com>
	<CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>
	<5423D80B.9060500@6wind.com>
	<CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com>
	<54256CCB.4000709@6wind.com> <5425BB3E.10700@gmail.com>
Date: Fri, 26 Sep 2014 12:34:16 -0700
In-Reply-To: <5425BB3E.10700@gmail.com> (David Ahern's message of "Fri, 26 Sep
	2014 13:15:10 -0600")
Message-ID: <87mw9myy4n.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19U38EMx7rEYS9W6ViK4eMakoa9EoTOKzc=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3322]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Ahern <lxhacker68@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <lxhacker68@gmail.com> writes:

> On 9/26/14, 7:40 AM, Nicolas Dichtel wrote:
>>>
>>>
>>> No, I don't want to monitor anything. Even if I wanted, I would just
>>> start one
>>> daemon in each netns instead of one for all.
>> Ok you don't want, but some other people (not only me) want it! And
>> having one
>> daemon per netns does not scale: there are scenarii with thousand netns
>> which
>> are dynamically created and deleted.
>
> An example of the scaling problem using quagga (old but still seems to be a
> relevant data point):
>
>
> https://lists.quagga.net/pipermail/quagga-users/2010-February/011351.html
>
> "2k VRFs that would be 2.6G"
>
> And that does not include the overhead of each namespace -- roughly
> 200kB/namespace on one kernel I checked (v3.10). So that's a ballpark of 3G of
> memory.

Resetting the conversation just a little bit.

When I wrote the "ip netns" support I never expected that all
applications would want to run in a specific network namespace.  All
that is needed is one socket per network namespace.

Furthermore one socket or one procesess per network namespaces is
completely orthogonal to the patches presented.  I do not see a
identifying where the far end of a veth pair or similar set of
networking objects as anything that even closely resembles a path to a
using only a single socket.

So I think this whole subthread is quite silly and grossly off track.

Eric
