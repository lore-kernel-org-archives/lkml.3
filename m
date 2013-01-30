Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3A3Udf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:33:35 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40067 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3A3Udc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:33:32 -0500
Message-ID: <51098397.5040206@suse.cz>
Date: Wed, 30 Jan 2013 21:33:27 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <CAErSpo4v473sXvmv3gqkftkiFZtz+gYgd1yzWae=nLJjwJPBug@mail.gmail.com> <20130130034204.GB30965@pd.tnic> <CAErSpo47BvEsDC1o_kYDeyd6j3VUoWHwSMYPyLpZYB1H-sL=7A@mail.gmail.com> <20130130174402.GB23980@pd.tnic> <510977FB.3030707@suse.cz> <20130130200041.GD23895@pd.tnic>
In-Reply-To: <20130130200041.GD23895@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: multipart/mixed;
 boundary="------------070205020708010107030003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070205020708010107030003
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/30/2013 09:00 PM, Borislav Petkov wrote:
> On Wed, Jan 30, 2013 at 08:43:55PM +0100, Jiri Slaby wrote:
>> On 01/30/2013 06:44 PM, Borislav Petkov wrote:
>>> On Wed, Jan 30, 2013 at 10:27:42AM -0700, Bjorn Helgaas wrote:
>>>> You're right, I don't think we're quite ready to merge those patches.
>>>> But if your NMI is easy to reproduce, it might be worth removing
>>>> e1000e altogether to see if it still happens.
>>>
>>> That's the problem - I've seen it only once so far. I'll watch out for
>>> it and do the above when I find a reliable way of reproducing it. Will
>>> keep you posted.
>>
>> It happens here too. Dunno what is the root cause. I *think* that it
>> never happened unless I used ethernet. Other than that I see no pattern.
>>
>> Attaching -C 20 grep of messages over the last half year if there is
>> something that may help somehow.
> 
> Cool, so it happens once a day, not every day, everytime during resume,
> and with e1000e. Can you try Bjorn's suggestion to remove e1000e
> altogether and see if it still happens?

No, e1000e is not to blame at all. I moved e1000e out of /lib/modules
and it still happens.

What is cool is that I have steps to reproduce:
1) boot
2) run the attached script (turn on all possible power savings -- in
fact everything what powertop suggests)
3) suspend to _disk_ (mem is not enough, BIOS apparently has to
interfere here)
4) resume from disk
5) boom

I tried to remove also wireless drivers, no change.

-- 
js
suse labs

--------------070205020708010107030003
Content-Type: text/plain; charset=UTF-8;
 name="power"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="power"

IyEvYmluL2Jhc2gKCkRJUlRZX1dCPTE1MDAKR09WRVJOPWNvbnNlcnZhdGl2ZQpQT1dFUk1P
REU9YXV0bwpOTUk9MApMSU5LX1BPVz1taW5fcG93ZXIKUE9XX1NBVkU9MQpQT1dfU0FWRV9U
WFQ9b24KCmlmIFsgIjAkMSIgLWVxIDEgXTsgdGhlbgojCURJUlRZX1dCPTE1MDAKCUdPVkVS
Tj1wZXJmb3JtYW5jZQoJUE9XRVJNT0RFPW9uCglOTUk9MQoJTElOS19QT1c9bWF4X3BlcmZv
cm1hbmNlCglQT1dfU0FWRT0wCglQT1dfU0FWRV9UWFQ9b2ZmCmZpCgovYmluL2VjaG8gLW4g
IiRESVJUWV9XQiIgPiAvcHJvYy9zeXMvdm0vZGlydHlfd3JpdGViYWNrX2NlbnRpc2Vjcwov
YmluL2VjaG8gLW4gIiROTUkiID4gL3Byb2Mvc3lzL2tlcm5lbC9ubWlfd2F0Y2hkb2cKL2Jp
bi9lY2hvIC1uICIkUE9XX1NBVkUiID4gL3N5cy9tb2R1bGUvc25kX2hkYV9pbnRlbC9wYXJh
bWV0ZXJzL3Bvd2VyX3NhdmUKaXcgZGV2IHdsYW4wIHNldCBwb3dlcl9zYXZlICIkUE9XX1NB
VkVfVFhUIgpldGh0b29sIC1zIGV0aDAgd29sIGQKCmZvciBCVVMgaW4gdXNiIHBjaTsgZG8g
Cglmb3IgREVWIGluIC9zeXMvYnVzLyRCVVMvZGV2aWNlcy8qL3Bvd2VyL2NvbnRyb2w7IGRv
CgkJL2Jpbi9lY2hvIC1uICIkUE9XRVJNT0RFIiA+ICRERVYKCWRvbmUKZG9uZQoKZm9yIENQ
VSBpbiAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS8qL2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5v
cjsgZG8KCS9iaW4vZWNobyAtbiAiJEdPVkVSTiIgPiAkQ1BVCmRvbmUKCmZvciBIT1NUIGlu
IC9zeXMvY2xhc3Mvc2NzaV9ob3N0L2hvc3QqL2xpbmtfcG93ZXJfbWFuYWdlbWVudF9wb2xp
Y3k7IGRvCgkvYmluL2VjaG8gLW4gIiRMSU5LX1BPVyIgPiAkSE9TVApkb25lCg==
--------------070205020708010107030003--
